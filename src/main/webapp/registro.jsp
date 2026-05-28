<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registro - Glow & Beauty</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            display: flex;
            background: linear-gradient(135deg, #ff9a9e 0%, #fad0c4 50%, #fbc2eb 100%);
        }

        .left-panel {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: 60px;
            color: #fff;
            position: relative;
            overflow: hidden;
        }

        .left-panel::before {
            content: '';
            position: absolute;
            width: 500px; height: 500px;
            background: rgba(255,255,255,0.1);
            border-radius: 50%;
            top: -150px; left: -150px;
        }

        .left-panel::after {
            content: '';
            position: absolute;
            width: 400px; height: 400px;
            background: rgba(255,255,255,0.08);
            border-radius: 50%;
            bottom: -100px; right: -100px;
        }

        .brand-logo {
            font-size: 4rem;
            margin-bottom: 30px;
            animation: float 3s ease-in-out infinite;
            position: relative; z-index: 1;
        }

        .brand-name {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 15px;
            text-shadow: 2px 2px 10px rgba(0,0,0,0.1);
            position: relative; z-index: 1;
        }

        .brand-tagline {
            font-size: 1.2rem;
            opacity: 0.95;
            text-align: center;
            max-width: 400px;
            line-height: 1.6;
            position: relative; z-index: 1;
        }

        .benefits {
            margin-top: 40px;
            list-style: none;
            position: relative; z-index: 1;
        }

        .benefits li {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 15px;
            font-size: 1rem;
        }

        .benefits li i {
            width: 30px; height: 30px;
            background: rgba(255,255,255,0.2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.9rem;
        }

        .right-panel {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 40px;
            overflow-y: auto;
        }

        .register-card {
            background: #fff;
            border-radius: 30px;
            padding: 50px;
            width: 100%;
            max-width: 480px;
            box-shadow: 0 25px 80px rgba(255,107,129,0.2);
            animation: slideIn 0.6s ease;
        }

        .register-header {
            text-align: center;
            margin-bottom: 35px;
        }

        .register-header h2 {
            color: #ff6b81;
            font-size: 2rem;
            margin-bottom: 10px;
        }

        .register-header p {
            color: #888;
            font-size: 0.95rem;
        }

        .register-header .icon-circle {
            width: 70px; height: 70px;
            background: linear-gradient(135deg, #ff9a9e, #fad0c4);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            font-size: 1.8rem;
            color: #fff;
            box-shadow: 0 10px 30px rgba(255,154,158,0.3);
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
        }

        .form-group {
            margin-bottom: 20px;
            position: relative;
        }

        .form-group.full-width {
            grid-column: 1 / -1;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #555;
            font-weight: 500;
            font-size: 0.9rem;
        }

        .input-wrapper {
            position: relative;
        }

        .input-wrapper i {
            position: absolute;
            left: 18px;
            top: 50%;
            transform: translateY(-50%);
            color: #ff9a9e;
            font-size: 1rem;
        }

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 14px 14px 14px 45px;
            border: 2px solid #ffe0e6;
            border-radius: 15px;
            font-size: 1rem;
            color: #333;
            transition: all 0.3s ease;
            background: #fdf6f9;
            appearance: none;
        }

        .form-group select {
            padding-right: 40px;
            cursor: pointer;
        }

        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #ff9a9e;
            background: #fff;
            box-shadow: 0 0 0 4px rgba(255,154,158,0.1);
        }

        .form-group input::placeholder {
            color: #bbb;
        }

        .select-wrapper {
            position: relative;
        }

        .select-wrapper::after {
            content: '\f078';
            font-family: 'Font Awesome 6 Free';
            font-weight: 900;
            position: absolute;
            right: 18px;
            top: 50%;
            transform: translateY(-50%);
            color: #ff9a9e;
            pointer-events: none;
            font-size: 0.9rem;
        }

        .password-toggle {
            position: absolute;
            right: 18px;
            top: 50%;
            transform: translateY(-50%);
            color: #ccc;
            cursor: pointer;
            transition: color 0.3s;
        }

        .password-toggle:hover {
            color: #ff9a9e;
        }

        .role-selector {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
            margin-bottom: 20px;
        }

        .role-option {
            position: relative;
            cursor: pointer;
        }

        .role-option input[type="radio"] {
            position: absolute;
            opacity: 0;
        }

        .role-card {
            border: 2px solid #ffe0e6;
            border-radius: 15px;
            padding: 20px;
            text-align: center;
            transition: all 0.3s ease;
            background: #fdf6f9;
        }

        .role-option input[type="radio"]:checked + .role-card {
            border-color: #ff9a9e;
            background: linear-gradient(135deg, #fff0f3, #ffe8ec);
            box-shadow: 0 5px 20px rgba(255,154,158,0.2);
        }

        .role-card i {
            font-size: 2rem;
            color: #ff9a9e;
            margin-bottom: 10px;
            display: block;
        }

        .role-card h4 {
            color: #333;
            font-size: 1rem;
            margin-bottom: 5px;
        }

        .role-card p {
            color: #888;
            font-size: 0.8rem;
        }

        .terms {
            display: flex;
            align-items: flex-start;
            gap: 10px;
            margin-bottom: 25px;
            font-size: 0.85rem;
            color: #666;
        }

        .terms input[type="checkbox"] {
            width: 18px; height: 18px;
            accent-color: #ff6b81;
            margin-top: 2px;
            flex-shrink: 0;
        }

        .terms a {
            color: #ff6b81;
            text-decoration: none;
        }

        .terms a:hover {
            text-decoration: underline;
        }

        .btn-register-submit {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #ff9a9e, #fad0c4);
            color: #fff;
            border: none;
            border-radius: 15px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 10px 30px rgba(255,154,158,0.3);
        }

        .btn-register-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 15px 40px rgba(255,154,158,0.4);
        }

        .btn-register-submit i {
            margin-left: 8px;
        }

        .login-link {
            text-align: center;
            margin-top: 25px;
            color: #888;
            font-size: 0.95rem;
        }

        .login-link a {
            color: #ff6b81;
            text-decoration: none;
            font-weight: 600;
        }

        .login-link a:hover {
            text-decoration: underline;
        }

        .back-home {
            text-align: center;
            margin-top: 15px;
        }

        .back-home a {
            color: #999;
            text-decoration: none;
            font-size: 0.9rem;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: color 0.3s;
        }

        .back-home a:hover {
            color: #ff6b81;
        }

        .alert {
            padding: 12px 18px;
            border-radius: 12px;
            margin-bottom: 20px;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .alert-error {
            background: #ffe0e0;
            color: #d32f2f;
            border: 1px solid #ffcdd2;
        }

        @keyframes slideIn {
            from { opacity: 0; transform: translateX(30px); }
            to { opacity: 1; transform: translateX(0); }
        }

        @keyframes float {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-15px); }
        }

        @media (max-width: 900px) {
            body { flex-direction: column; }
            .left-panel { padding: 40px 20px; min-height: 250px; }
            .brand-name { font-size: 2rem; }
            .right-panel { padding: 30px 20px; }
            .register-card { padding: 35px 25px; }
        }

        @media (max-width: 480px) {
            .form-row { grid-template-columns: 1fr; }
            .role-selector { grid-template-columns: 1fr; }
            .register-card { padding: 30px 20px; border-radius: 20px; }
        }
    </style>
</head>
<body>

    <div class="left-panel">
        <div class="brand-logo"><i class="fas fa-spa"></i></div>
        <h1 class="brand-name">Glow & Beauty</h1>
        <p class="brand-tagline">
            Únete a nuestra comunidad y descubre un mundo de belleza, bienestar y exclusivos beneficios.
        </p>
        <ul class="benefits">
            <li><i class="fas fa-gift"></i><span>20% de descuento en tu primera compra</span></li>
            <li><i class="fas fa-calendar-check"></i><span>Agenda citas sin filas ni esperas</span></li>
            <li><i class="fas fa-star"></i><span>Acumula puntos y canjea premios</span></li>
            <li><i class="fas fa-bell"></i><span>Notificaciones de promociones exclusivas</span></li>
        </ul>
    </div>

    <div class="right-panel">
        <div class="register-card">
            <div class="register-header">
                <div class="icon-circle"><i class="fas fa-user-plus"></i></div>
                <h2>Crear Cuenta</h2>
                <p>Completa tus datos para registrarte</p>
            </div>

            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i>
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>

            <form action="<%= request.getContextPath() %>/registro" method="POST" id="registerForm">
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="nombre">Nombre</label>
                        <div class="input-wrapper">
                            <i class="fas fa-user"></i>
                            <input type="text" id="nombre" name="nombre" placeholder="Tu nombre" required
                                value="<%= request.getParameter("nombre") != null ? request.getParameter("nombre") : "" %>">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="apellido">Apellido</label>
                        <div class="input-wrapper">
                            <i class="fas fa-user"></i>
                            <input type="text" id="apellido" name="apellido" placeholder="Tu apellido" required
                                value="<%= request.getParameter("apellido") != null ? request.getParameter("apellido") : "" %>">
                        </div>
                    </div>
                </div>

                <div class="form-group full-width">
                    <label for="email">Correo Electrónico</label>
                    <div class="input-wrapper">
                        <i class="fas fa-envelope"></i>
                        <input type="email" id="email" name="email" placeholder="tu@email.com" required
                            value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="documento">Documento</label>
                        <div class="input-wrapper">
                            <i class="fas fa-id-card"></i>
                            <input type="text" id="documento" name="documento" placeholder="1234567890" required
                                value="<%= request.getParameter("documento") != null ? request.getParameter("documento") : "" %>">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="userName">Nombre de Usuario</label>
                        <div class="input-wrapper">
                            <i class="fas fa-at"></i>
                            <input type="text" id="userName" name="userName" placeholder="@usuario" required
                                value="<%= request.getParameter("userName") != null ? request.getParameter("userName") : "" %>">
                        </div>
                    </div>
                </div>

                <div class="form-group full-width">
                    <label>Selecciona tu Rol</label>
                    <div class="role-selector">
                        <label class="role-option">
                            <input type="radio" name="rol" value="COMPRADOR" checked>
                            <div class="role-card">
                                <i class="fas fa-shopping-bag"></i>
                                <h4>Comprador</h4>
                                <p>Compra productos y reserva servicios</p>
                            </div>
                        </label>
                        <label class="role-option">
                            <input type="radio" name="rol" value="USUARIO">
                            <div class="role-card">
                                <i class="fas fa-user-circle"></i>
                                <h4>Usuario</h4>
                                <p>Accede a contenido y comunidad</p>
                            </div>
                        </label>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="contrasena">Contraseña</label>
                        <div class="input-wrapper">
                            <i class="fas fa-lock"></i>
                            <input type="password" id="contrasena" name="contrasena" placeholder="Mínimo 6 caracteres" required minlength="6">
                            <i class="fas fa-eye password-toggle" onclick="togglePassword('contrasena', this)"></i>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="confirmarContrasena">Confirmar Contraseña</label>
                        <div class="input-wrapper">
                            <i class="fas fa-lock"></i>
                            <input type="password" id="confirmarContrasena" name="confirmarContrasena" placeholder="Repite tu contraseña" required minlength="6">
                            <i class="fas fa-eye password-toggle" onclick="togglePassword('confirmarContrasena', this)"></i>
                        </div>
                    </div>
                </div>

                <div class="terms">
                    <input type="checkbox" id="terminos" name="terminos" required>
                    <label for="terminos">
                        Acepto los <a href="#">Términos y Condiciones</a> y la <a href="#">Política de Privacidad</a> de Glow & Beauty.
                    </label>
                </div>

                <button type="submit" class="btn-register-submit">
                    Crear Cuenta <i class="fas fa-arrow-right"></i>
                </button>
            </form>

            <div class="login-link">
                ¿Ya tienes una cuenta? <a href="login.jsp">Inicia sesión aquí</a>
            </div>

            <div class="back-home">
                <a href="index.jsp"><i class="fas fa-arrow-left"></i> Volver al inicio</a>
            </div>
        </div>
    </div>

    <script>
        function togglePassword(inputId, icon) {
            const input = document.getElementById(inputId);
            if (input.type === 'password') {
                input.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                input.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        }

        document.getElementById('registerForm').addEventListener('submit', function(e) {
            const password = document.getElementById('contrasena').value;
            const confirmPassword = document.getElementById('confirmarContrasena').value;

            if (password !== confirmPassword) {
                e.preventDefault();
                alert('Las contraseñas no coinciden. Por favor verifica.');
                document.getElementById('confirmarContrasena').focus();
            }
        });
    </script>
 <%@ include file="chatbot.jsp" %>
</body>
</html>