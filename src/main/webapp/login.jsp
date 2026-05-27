<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Acceder - Glow & Beauty</title>
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

        .features-list {
            margin-top: 40px;
            list-style: none;
            position: relative; z-index: 1;
        }

        .features-list li {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 15px;
            font-size: 1rem;
        }

        .features-list li i {
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
        }

        .login-card {
            background: #fff;
            border-radius: 30px;
            padding: 50px;
            width: 100%;
            max-width: 450px;
            box-shadow: 0 25px 80px rgba(255,107,129,0.2);
            animation: slideIn 0.6s ease;
        }

        .login-header {
            text-align: center;
            margin-bottom: 40px;
        }

        .login-header h2 {
            color: #ff6b81;
            font-size: 2rem;
            margin-bottom: 10px;
        }

        .login-header p {
            color: #888;
            font-size: 0.95rem;
        }

        .login-header .icon-circle {
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

        .form-group {
            margin-bottom: 25px;
            position: relative;
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

        .form-group input {
            width: 100%;
            padding: 14px 14px 14px 45px;
            border: 2px solid #ffe0e6;
            border-radius: 15px;
            font-size: 1rem;
            color: #333;
            transition: all 0.3s ease;
            background: #fdf6f9;
        }

        .form-group input:focus {
            outline: none;
            border-color: #ff9a9e;
            background: #fff;
            box-shadow: 0 0 0 4px rgba(255,154,158,0.1);
        }

        .form-group input::placeholder {
            color: #bbb;
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

        .form-options {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            font-size: 0.9rem;
        }

        .remember-me {
            display: flex;
            align-items: center;
            gap: 8px;
            color: #666;
            cursor: pointer;
        }

        .remember-me input[type="checkbox"] {
            width: 18px; height: 18px;
            accent-color: #ff6b81;
            cursor: pointer;
        }

        .forgot-password {
            color: #ff6b81;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.3s;
        }

        .forgot-password:hover {
            color: #ff4757;
            text-decoration: underline;
        }

        .btn-login-submit {
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

        .btn-login-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 15px 40px rgba(255,154,158,0.4);
        }

        .btn-login-submit i {
            margin-left: 8px;
            transition: transform 0.3s;
        }

        .btn-login-submit:hover i {
            transform: translateX(4px);
        }

        .divider {
            display: flex;
            align-items: center;
            margin: 30px 0;
            color: #ccc;
            font-size: 0.85rem;
        }

        .divider::before, .divider::after {
            content: '';
            flex: 1;
            height: 1px;
            background: #eee;
        }

        .divider span {
            padding: 0 15px;
        }

        .social-login {
            display: flex;
            gap: 15px;
            justify-content: center;
        }

        .social-btn {
            flex: 1;
            padding: 12px;
            border: 2px solid #ffe0e6;
            border-radius: 12px;
            background: #fff;
            color: #666;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .social-btn:hover {
            border-color: #ff9a9e;
            background: #fdf6f9;
            transform: translateY(-2px);
        }

        .social-btn.google:hover { color: #db4437; border-color: #db4437; }
        .social-btn.facebook:hover { color: #4267B2; border-color: #4267B2; }

        .register-link {
            text-align: center;
            margin-top: 30px;
            color: #888;
            font-size: 0.95rem;
        }

        .register-link a {
            color: #ff6b81;
            text-decoration: none;
            font-weight: 600;
        }

        .register-link a:hover {
            text-decoration: underline;
        }

        .back-home {
            text-align: center;
            margin-top: 20px;
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

        .alert-success {
            background: #e8f5e9;
            color: #388e3c;
            border: 1px solid #c8e6c9;
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
            .left-panel { padding: 40px 20px; min-height: 300px; }
            .brand-name { font-size: 2rem; }
            .right-panel { padding: 30px 20px; }
            .login-card { padding: 35px 25px; }
        }

        @media (max-width: 480px) {
            .login-card { padding: 30px 20px; border-radius: 20px; }
            .social-login { flex-direction: column; }
            .form-options { flex-direction: column; gap: 15px; align-items: flex-start; }
        }
    </style>
</head>
<body>

    <div class="left-panel">
        <div class="brand-logo"><i class="fas fa-spa"></i></div>
        <h1 class="brand-name">Glow & Beauty</h1>
        <p class="brand-tagline">
            Tu centro de belleza de confianza. Accede a tu cuenta para gestionar citas, 
            ver historial de tratamientos y disfrutar de beneficios exclusivos.
        </p>
        <ul class="features-list">
            <li><i class="fas fa-check"></i><span>Reserva citas en línea 24/7</span></li>
            <li><i class="fas fa-check"></i><span>Historial completo de servicios</span></li>
            <li><i class="fas fa-check"></i><span>Promociones exclusivas para miembros</span></li>
            <li><i class="fas fa-check"></i><span>Recordatorios automáticos por email</span></li>
        </ul>
    </div>

    <div class="right-panel">
        <div class="login-card">
            <div class="login-header">
                <div class="icon-circle"><i class="fas fa-user"></i></div>
                <h2>¡Bienvenida de nuevo!</h2>
                <p>Ingresa tus credenciales para acceder a tu cuenta</p>
            </div>

            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i>
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>

            <% if ("ok".equals(request.getParameter("registro"))) { %>
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i>
                    ¡Registro exitoso! Ahora puedes iniciar sesión.
                </div>
            <% } %>

            <!-- ✅ CORREGIDO: name="contrasena" y accept-charset -->
            <form action="${pageContext.request.contextPath}/login" method="POST" accept-charset="UTF-8">
                
                <div class="form-group">
                    <label for="email">Correo o Usuario</label>
                    <div class="input-wrapper">
                        <i class="fas fa-user"></i>
                        <input type="text" id="email" name="email" placeholder="tu@email.com o tu_usuario" required
                            value="<%= request.getAttribute("emailPrevio") != null ? request.getAttribute("emailPrevio") : (request.getParameter("email") != null ? request.getParameter("email") : "") %>">
                    </div>
                </div>

                <div class="form-group">
                    <label for="password">Contraseña</label>
                    <div class="input-wrapper">
                        <i class="fas fa-lock"></i>
                        <!-- ✅ CORREGIDO: name="contrasena" (antes era "password") -->
                        <input type="password" id="password" name="contrasena" placeholder="••••••••" required>
                        <i class="fas fa-eye password-toggle" onclick="togglePassword()" id="toggleIcon"></i>
                    </div>
                </div>

                <div class="form-options">
                    <label class="remember-me">
                        <input type="checkbox" name="remember" id="remember">
                        <span>Recordarme</span>
                    </label>
                    <a href="recuperar-password.jsp" class="forgot-password">¿Olvidaste tu contraseña?</a>
                </div>

                <button type="submit" class="btn-login-submit">
                    Iniciar Sesión <i class="fas fa-arrow-right"></i>
                </button>
            </form>

            <div class="divider"><span>O continúa con</span></div>

            <div class="social-login">
                <button type="button" class="social-btn google" onclick="alert('Login con Google - Implementar OAuth')">
                    <i class="fab fa-google"></i> Google
                </button>
                <button type="button" class="social-btn facebook" onclick="alert('Login con Facebook - Implementar OAuth')">
                    <i class="fab fa-facebook-f"></i> Facebook
                </button>
            </div>

            <div class="register-link">
                ¿No tienes una cuenta? <a href="registro.jsp">Regístrate aquí</a>
            </div>

            <div class="back-home">
                <a href="index.jsp"><i class="fas fa-arrow-left"></i> Volver al inicio</a>
            </div>
        </div>
    </div>

    <script>
        function togglePassword() {
            const passwordInput = document.getElementById('password');
            const toggleIcon = document.getElementById('toggleIcon');
            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                toggleIcon.classList.remove('fa-eye');
                toggleIcon.classList.add('fa-eye-slash');
            } else {
                passwordInput.type = 'password';
                toggleIcon.classList.remove('fa-eye-slash');
                toggleIcon.classList.add('fa-eye');
            }
        }
    </script>

</body>
</html>