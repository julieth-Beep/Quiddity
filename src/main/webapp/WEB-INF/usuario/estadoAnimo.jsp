<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="com.quiddity.model.Usuario" %>
<%
    HttpSession sesion = request.getSession(false);
    if (sesion == null || sesion.getAttribute("usuario") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    Usuario usuario = (Usuario) sesion.getAttribute("usuario");
    String nombreUsuario = usuario.getNombre();

    // Si ya seleccionó estado de ánimo hoy, ir al home
    if (sesion.getAttribute("estadoAnimoSeleccionado") != null) {
        response.sendRedirect(request.getContextPath() + "/inicio");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>¿Cómo te sientes hoy? - Quiddity</title>
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Nunito', sans-serif;
            min-height: 100vh;
            background: linear-gradient(135deg, #fce4ec 0%, #f8bbd0 40%, #e1bee7 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }

        /* ── Frase flotante esquina inferior derecha ── */
        .frase-widget {
            position: fixed;
            bottom: 0;
            right: 0;
            display: flex;
            align-items: flex-end;
            z-index: 100;
            pointer-events: none;
            opacity: 0;
            transform: translateY(30px);
            transition: opacity 0.6s ease, transform 0.6s ease;
        }

        .frase-widget.visible {
            opacity: 1;
            transform: translateY(0);
        }

        .frase-card {
            background: white;
            border-radius: 16px 16px 4px 16px;
            padding: 14px 18px;
            max-width: 200px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.12);
            border: 1.5px solid #f8bbd0;
            margin-bottom: 20px;
            position: relative;
        }

        .frase-card::after {
            content: '';
            position: absolute;
            bottom: -1px;
            right: -13px;
            width: 0; height: 0;
            border-left: 14px solid white;
            border-top: 12px solid transparent;
        }

        .frase-card img {
            width: 100%;
            border-radius: 8px;
            display: block;
        }

        .mascota-img {
            width: 160px;
            mix-blend-mode: multiply;  /* elimina fondo blanco */
            margin-bottom: -4px;
            filter: drop-shadow(0 -2px 8px rgba(0,0,0,0.08));
        }

        /* ── Contenido central ── */
        .container {
            background: white;
            border-radius: 28px;
            padding: 50px 40px;
            max-width: 520px;
            width: 90%;
            box-shadow: 0 20px 60px rgba(233,30,99,0.15);
            text-align: center;
            position: relative;
            z-index: 10;
        }

        .greeting {
            font-size: 1rem;
            color: #e91e63;
            font-weight: 600;
            margin-bottom: 8px;
            letter-spacing: 0.5px;
        }

        .title {
            font-size: 1.9rem;
            font-weight: 800;
            color: #333;
            margin-bottom: 8px;
            line-height: 1.2;
        }

        .subtitle {
            font-size: 0.95rem;
            color: #888;
            margin-bottom: 36px;
        }

        /* ── Botones de estado de ánimo ── */
        .estados-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 14px;
            margin-bottom: 32px;
        }

        .estado-btn {
            background: #fdf6f9;
            border: 2px solid #f8bbd0;
            border-radius: 18px;
            padding: 20px 12px;
            cursor: pointer;
            transition: all 0.25s ease;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 8px;
            text-decoration: none;
        }

        .estado-btn:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 24px rgba(233,30,99,0.15);
        }

        .estado-btn.selected {
            border-color: #e91e63;
            background: #fce4ec;
            transform: translateY(-4px);
            box-shadow: 0 8px 24px rgba(233,30,99,0.2);
        }

        .estado-emoji {
            font-size: 2.4rem;
            line-height: 1;
        }

        .estado-label {
            font-size: 0.95rem;
            font-weight: 700;
            color: #555;
        }

        .estado-btn.selected .estado-label {
            color: #e91e63;
        }

        /* Colores por estado */
        .estado-btn[data-estado="feliz"]:hover,
        .estado-btn[data-estado="feliz"].selected {
            border-color: #f06292;
            background: #fce4ec;
            box-shadow: 0 8px 24px rgba(240,98,146,0.2);
        }

        .estado-btn[data-estado="triste"]:hover,
        .estado-btn[data-estado="triste"].selected {
            border-color: #7986cb;
            background: #e8eaf6;
            box-shadow: 0 8px 24px rgba(121,134,203,0.2);
        }

        .estado-btn[data-estado="enojado"]:hover,
        .estado-btn[data-estado="enojado"].selected {
            border-color: #e57373;
            background: #ffebee;
            box-shadow: 0 8px 24px rgba(229,115,115,0.2);
        }

        .estado-btn[data-estado="neutra"]:hover,
        .estado-btn[data-estado="neutra"].selected {
            border-color: #81c784;
            background: #e8f5e9;
            box-shadow: 0 8px 24px rgba(129,199,132,0.2);
        }

        .btn-continuar {
            width: 100%;
            padding: 16px;
            background: linear-gradient(135deg, #f06292, #e91e63);
            color: white;
            border: none;
            border-radius: 16px;
            font-size: 1.05rem;
            font-weight: 700;
            font-family: 'Nunito', sans-serif;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 8px 24px rgba(233,30,99,0.3);
            display: none;
        }

        .btn-continuar:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 32px rgba(233,30,99,0.4);
        }

        .btn-continuar.visible {
            display: block;
            animation: fadeUp 0.3s ease;
        }

        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(10px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        /* ── Mensaje de carga ── */
        .loading {
            display: none;
            font-size: 0.9rem;
            color: #e91e63;
            margin-top: 12px;
        }

        @media (max-width: 480px) {
            .container { padding: 36px 24px; }
            .title { font-size: 1.5rem; }
            .mascota-img { width: 120px; }
            .frase-card { max-width: 160px; padding: 10px 12px; }
        }
    </style>
</head>
<body>

    <!-- ── Panel central ── -->
    <div class="container">
        <p class="greeting">¡Hola, <%= nombreUsuario %>! 👋</p>
        <h1 class="title">¿Cómo te sientes<br>hoy?</h1>
        <p class="subtitle">Elige tu estado de ánimo y te mostramos algo especial</p>

        <form id="estadoForm" action="<%= request.getContextPath() %>/estadoAnimo" method="POST">
            <input type="hidden" name="estado" id="estadoInput" value="">

            <div class="estados-grid">
                <button type="button" class="estado-btn" data-estado="feliz" onclick="seleccionar(this)">
                    <span class="estado-emoji">😊</span>
                    <span class="estado-label">Feliz</span>
                </button>
                <button type="button" class="estado-btn" data-estado="triste" onclick="seleccionar(this)">
                    <span class="estado-emoji">😢</span>
                    <span class="estado-label">Triste</span>
                </button>
                <button type="button" class="estado-btn" data-estado="enojado" onclick="seleccionar(this)">
                    <span class="estado-emoji">😠</span>
                    <span class="estado-label">Enojada</span>
                </button>
                <button type="button" class="estado-btn" data-estado="neutra" onclick="seleccionar(this)">
                    <span class="estado-emoji">😌</span>
                    <span class="estado-label">Tranquila</span>
                </button>
            </div>

            <button type="submit" class="btn-continuar" id="btnContinuar">
                Ver mi frase ✨
            </button>
            <p class="loading" id="loadingMsg">Buscando tu frase...</p>
        </form>
    </div>

    <!-- ── Widget frase + mascota (esquina inferior derecha) ── -->
    <div class="frase-widget" id="fraseWidget">
        <div class="frase-card" id="fraseCard">
            <img id="fraseImg" src="" alt="Frase motivacional">
        </div>
        <img
            class="mascota-img"
            src="<%= request.getContextPath() %>/uploads/frase/mascota1.jpg"
            alt="Mascota Quiddity saludando"
        >
    </div>

    <script>
        const fraseWidget = document.getElementById('fraseWidget');
        const fraseImg    = document.getElementById('fraseImg');
        const btnContinuar = document.getElementById('btnContinuar');
        const estadoInput  = document.getElementById('estadoInput');
        const loadingMsg   = document.getElementById('loadingMsg');

        // Rutas de frases por estado (imagen local del proyecto)
        const rutasFrases = {
            feliz:   '<%= request.getContextPath() %>/uploads/frase/feliz/feliz.jpg',
            triste:  '<%= request.getContextPath() %>/uploads/frase/triste/triste.jpg',
            enojado: '<%= request.getContextPath() %>/uploads/frase/enojado/enojado.jpg',
            neutra:  '<%= request.getContextPath() %>/uploads/frase/neutra/neutro.jpg'
        };

        function seleccionar(btn) {
            // Quitar selección previa
            document.querySelectorAll('.estado-btn').forEach(b => b.classList.remove('selected'));
            btn.classList.add('selected');

            const estado = btn.dataset.estado;
            estadoInput.value = estado;

            // Mostrar imagen de frase en el widget
            fraseImg.src = rutasFrases[estado];
            fraseWidget.classList.add('visible');

            // Mostrar botón continuar
            btnContinuar.classList.add('visible');
        }

        // Al enviar el form mostrar loading
        document.getElementById('estadoForm').addEventListener('submit', function(e) {
            if (!estadoInput.value) {
                e.preventDefault();
                return;
            }
            btnContinuar.style.display = 'none';
            loadingMsg.style.display = 'block';
        });
    </script>

</body>
</html>
