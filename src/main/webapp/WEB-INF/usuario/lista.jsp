<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Glow & Beauty - Centro de Belleza</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #fdf6f9;
            color: #333;
            line-height: 1.6;
        }

        /* ===== NAVBAR ===== */
        .navbar {
            background: linear-gradient(135deg, #ff9a9e 0%, #fad0c4 50%, #fad0c4 100%);
            padding: 0 5%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            height: 70px;
            position: fixed;
            width: 100%;
            top: 0;
            z-index: 1000;
            box-shadow: 0 2px 20px rgba(255, 154, 158, 0.3);
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 1.5rem;
            font-weight: 700;
            color: #fff;
            text-decoration: none;
        }

        .logo i {
            font-size: 1.8rem;
        }

        .nav-links {
            display: flex;
            list-style: none;
            gap: 30px;
            align-items: center;
        }

        .nav-links a {
            text-decoration: none;
            color: #fff;
            font-weight: 500;
            font-size: 1rem;
            transition: all 0.3s ease;
            position: relative;
        }

        .nav-links a::after {
            content: '';
            position: absolute;
            bottom: -5px;
            left: 0;
            width: 0;
            height: 2px;
            background: #fff;
            transition: width 0.3s ease;
        }

        .nav-links a:hover::after {
            width: 100%;
        }

        .btn-login {
            background: #fff;
            color: #ff6b81 !important;
            padding: 8px 24px;
            border-radius: 25px;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(255, 107, 129, 0.3);
        }

        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(255, 107, 129, 0.4);
        }

        .btn-login::after {
            display: none !important;
        }

        .menu-toggle {
            display: none;
            color: #fff;
            font-size: 1.5rem;
            cursor: pointer;
        }

        /* ===== HERO ===== */
        .hero {
            margin-top: 70px;
            background: linear-gradient(135deg, #ff9a9e 0%, #fad0c4 50%, #fbc2eb 100%);
            min-height: 90vh;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            padding: 0 5%;
            position: relative;
            overflow: hidden;
        }

        .hero::before {
            content: '';
            position: absolute;
            width: 400px;
            height: 400px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
            top: -100px;
            right: -100px;
        }

        .hero::after {
            content: '';
            position: absolute;
            width: 300px;
            height: 300px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
            bottom: -50px;
            left: -50px;
        }

        .hero-content {
            position: relative;
            z-index: 1;
            max-width: 800px;
        }

        .hero h1 {
            font-size: 3.5rem;
            color: #fff;
            margin-bottom: 20px;
            text-shadow: 2px 2px 10px rgba(0,0,0,0.1);
            animation: fadeInUp 1s ease;
        }

        .hero p {
            font-size: 1.3rem;
            color: #fff;
            margin-bottom: 40px;
            opacity: 0.95;
            animation: fadeInUp 1s ease 0.2s both;
        }

        .hero-buttons {
            display: flex;
            gap: 20px;
            justify-content: center;
            animation: fadeInUp 1s ease 0.4s both;
        }

        .btn-primary {
            background: #fff;
            color: #ff6b81;
            padding: 14px 40px;
            border-radius: 30px;
            text-decoration: none;
            font-weight: 600;
            font-size: 1.1rem;
            transition: all 0.3s ease;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        }

        .btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 30px rgba(0,0,0,0.15);
        }

        .btn-secondary {
            background: transparent;
            color: #fff;
            padding: 14px 40px;
            border-radius: 30px;
            text-decoration: none;
            font-weight: 600;
            font-size: 1.1rem;
            border: 2px solid #fff;
            transition: all 0.3s ease;
        }

        .btn-secondary:hover {
            background: #fff;
            color: #ff6b81;
        }

        /* ===== SERVICIOS ===== */
        .services {
            padding: 80px 5%;
            text-align: center;
        }

        .section-title {
            font-size: 2.5rem;
            color: #ff6b81;
            margin-bottom: 15px;
        }

        .section-subtitle {
            color: #888;
            font-size: 1.1rem;
            margin-bottom: 50px;
        }

        .services-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 30px;
            max-width: 1200px;
            margin: 0 auto;
        }

        .service-card {
            background: #fff;
            border-radius: 20px;
            padding: 40px 30px;
            box-shadow: 0 10px 40px rgba(255, 154, 158, 0.1);
            transition: all 0.4s ease;
            border: 1px solid #ffe0e6;
        }

        .service-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 60px rgba(255, 154, 158, 0.2);
        }

        .service-icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #ff9a9e, #fad0c4);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            font-size: 2rem;
            color: #fff;
        }

        .service-card h3 {
            color: #333;
            margin-bottom: 15px;
            font-size: 1.3rem;
        }

        .service-card p {
            color: #777;
            font-size: 0.95rem;
        }

        /* ===== GALERÍA ===== */
        .gallery {
            padding: 60px 5%;
            background: #fff;
        }

        .gallery-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            max-width: 1200px;
            margin: 0 auto;
        }

        .gallery-item {
            border-radius: 15px;
            overflow: hidden;
            height: 300px;
            position: relative;
            cursor: pointer;
        }

        .gallery-item img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s ease;
        }

        .gallery-item:hover img {
            transform: scale(1.1);
        }

        .gallery-overlay {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            background: linear-gradient(transparent, rgba(255, 107, 129, 0.8));
            padding: 30px 20px 20px;
            color: #fff;
            transform: translateY(100%);
            transition: transform 0.3s ease;
        }

        .gallery-item:hover .gallery-overlay {
            transform: translateY(0);
        }

        /* ===== TESTIMONIOS ===== */
        .testimonials {
            padding: 80px 5%;
            background: linear-gradient(135deg, #fdf6f9, #ffe0e6);
        }

        .testimonials-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 30px;
            max-width: 1000px;
            margin: 0 auto;
        }

        .testimonial-card {
            background: #fff;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.05);
            text-align: center;
        }

        .testimonial-card .stars {
            color: #ffc107;
            margin-bottom: 15px;
            font-size: 1.2rem;
        }

        .testimonial-card p {
            color: #666;
            font-style: italic;
            margin-bottom: 20px;
            line-height: 1.8;
        }

        .testimonial-card .client-name {
            color: #ff6b81;
            font-weight: 600;
        }

        .testimonial-card .client-role {
            color: #999;
            font-size: 0.9rem;
        }

        /* ===== CTA ===== */
        .cta-section {
            padding: 80px 5%;
            text-align: center;
            background: linear-gradient(135deg, #ff9a9e, #fad0c4);
            color: #fff;
        }

        .cta-section h2 {
            font-size: 2.5rem;
            margin-bottom: 20px;
        }

        .cta-section p {
            font-size: 1.2rem;
            margin-bottom: 30px;
            opacity: 0.95;
        }

        /* ===== FOOTER ===== */
        .footer {
            background: #2d2d2d;
            color: #fff;
            padding: 60px 5% 30px;
        }

        .footer-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 40px;
            max-width: 1200px;
            margin: 0 auto 40px;
        }

        .footer-col h4 {
            color: #ff9a9e;
            margin-bottom: 20px;
            font-size: 1.2rem;
        }

        .footer-col p, .footer-col a {
            color: #aaa;
            text-decoration: none;
            line-height: 2;
            transition: color 0.3s;
        }

        .footer-col a:hover {
            color: #ff9a9e;
        }

        .social-links {
            display: flex;
            gap: 15px;
            margin-top: 15px;
        }

        .social-links a {
            width: 40px;
            height: 40px;
            background: rgba(255,255,255,0.1);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            transition: all 0.3s;
        }

        .social-links a:hover {
            background: #ff9a9e;
            transform: translateY(-3px);
        }

        .footer-bottom {
            text-align: center;
            padding-top: 30px;
            border-top: 1px solid #444;
            color: #888;
        }

        /* ===== ANIMACIONES ===== */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* ===== RESPONSIVE ===== */
        @media (max-width: 768px) {
            .nav-links {
                display: none;
                position: absolute;
                top: 70px;
                left: 0;
                width: 100%;
                background: linear-gradient(135deg, #ff9a9e, #fad0c4);
                flex-direction: column;
                padding: 20px;
                gap: 15px;
            }

            .nav-links.active {
                display: flex;
            }

            .menu-toggle {
                display: block;
            }

            .hero h1 {
                font-size: 2.2rem;
            }

            .hero p {
                font-size: 1rem;
            }

            .hero-buttons {
                flex-direction: column;
                align-items: center;
            }

            .section-title {
                font-size: 2rem;
            }
        }
    </style>
</head>
<body>

    <!-- NAVBAR -->
    <nav class="navbar">
        <a href="index.jsp" class="logo">
            <i class="fas fa-spa"></i>
            Glow & Beauty
        </a>
        <ul class="nav-links" id="navLinks">
            <li><a href="index.jsp"><i class="fas fa-home"></i> Inicio</a></li>
            <li><a href="#servicios">Servicios</a></li>
            <li><a href="#galeria">Galería</a></li>
            <li><a href="#testimonios">Testimonios</a></li>
            <li><a href="#contacto">Contacto</a></li>
            <li><a href="login.jsp" class="btn-login"><i class="fas fa-user"></i> Acceder</a></li>
        </ul>
        <div class="menu-toggle" onclick="toggleMenu()">
            <i class="fas fa-bars"></i>
        </div>
    </nav>

    <!-- HERO -->
    <section class="hero">
        <div class="hero-content">
            <h1>Realza tu Belleza Natural</h1>
            <p>Descubre un oasis de bienestar donde la elegancia y el cuidado personal se encuentran. Nuestros expertos te brindarán una experiencia única de transformación.</p>
            <div class="hero-buttons">
                <a href="#servicios" class="btn-primary">Ver Servicios</a>
                <a href="login.jsp" class="btn-secondary">Reservar Cita</a>
            </div>
        </div>
    </section>

    <!-- SERVICIOS -->
    <section class="services" id="servicios">
        <h2 class="section-title">Nuestros Servicios</h2>
        <p class="section-subtitle">Tratamientos exclusivos diseñados para ti</p>
        <div class="services-grid">
            <div class="service-card">
                <div class="service-icon"><i class="fas fa-cut"></i></div>
                <h3>Estilismo & Corte</h3>
                <p>Cortes modernos, coloración profesional y tratamientos capilares que realzan tu estilo personal.</p>
            </div>
            <div class="service-card">
                <div class="service-icon"><i class="fas fa-hand-sparkles"></i></div>
                <h3>Manicure & Pedicure</h3>
                <p>Diseño de uñas artísticas, spa de manos y pies con productos de alta gama para un acabado perfecto.</p>
            </div>
            <div class="service-card">
                <div class="service-icon"><i class="fas fa-face-smile-beam"></i></div>
                <h3>Faciales & Spa</h3>
                <p>Tratamientos faciales rejuvenecedores, limpieza profunda y mascarillas orgánicas para una piel radiante.</p>
            </div>
            <div class="service-card">
                <div class="service-icon"><i class="fas fa-wand-magic-sparkles"></i></div>
                <h3>Maquillaje Profesional</h3>
                <p>Maquillaje para eventos, bodas y sesiones fotográficas con técnicas de última tendencia.</p>
            </div>
            <div class="service-card">
                <div class="service-icon"><i class="fas fa-hot-tub-person"></i></div>
                <h3>Masajes Terapéuticos</h3>
                <p>Masajes relajantes, descontracturantes y aromaterapia para liberar el estrés y revitalizar tu cuerpo.</p>
            </div>
            <div class="service-card">
                <div class="service-icon"><i class="fas fa-spray-can-sparkles"></i></div>
                <h3>Depilación & Bronceado</h3>
                <p>Depilación con cera de alta calidad y bronceado orgánico para una piel suave y luminosa.</p>
            </div>
        </div>
    </section>

    <!-- GALERÍA -->
    <section class="gallery" id="galeria">
        <h2 class="section-title" style="text-align:center; margin-bottom:15px;">Galería de Transformaciones</h2>
        <p class="section-subtitle" style="text-align:center; margin-bottom:50px;">Resultados que hablan por sí solos</p>
        <div class="gallery-grid">
            <div class="gallery-item">
                <img src="https://images.unsplash.com/photo-1560066984-138dadb4c035?w=400&h=400&fit=crop" alt="Estilismo">
                <div class="gallery-overlay">
                    <h4>Estilismo Premium</h4>
                </div>
            </div>
            <div class="gallery-item">
                <img src="https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=400&h=400&fit=crop" alt="Maquillaje">
                <div class="gallery-overlay">
                    <h4>Maquillaje Artístico</h4>
                </div>
            </div>
            <div class="gallery-item">
                <img src="https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?w=400&h=400&fit=crop" alt="Facial">
                <div class="gallery-overlay">
                    <h4>Tratamientos Faciales</h4>
                </div>
            </div>
            <div class="gallery-item">
                <img src="https://images.unsplash.com/photo-1604654894610-df63bc536371?w=400&h=400&fit=crop" alt="Uñas">
                <div class="gallery-overlay">
                    <h4>Diseño de Uñas</h4>
                </div>
            </div>
        </div>
    </section>

    <!-- TESTIMONIOS -->
    <section class="testimonials" id="testimonios">
        <h2 class="section-title" style="text-align:center; margin-bottom:15px;">Lo que dicen nuestras clientas</h2>
        <p class="section-subtitle" style="text-align:center; margin-bottom:50px;">Experiencias reales de transformación</p>
        <div class="testimonials-grid">
            <div class="testimonial-card">
                <div class="stars">
                    <i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i>
                </div>
                <p>"El mejor centro de belleza al que he ido. El equipo es increíblemente profesional y el ambiente es simplemente mágico. ¡Mi cabello nunca se había visto mejor!"</p>
                <div class="client-name">María Fernanda López</div>
                <div class="client-role">Cliente VIP</div>
            </div>
            <div class="testimonial-card">
                <div class="stars">
                    <i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i>
                </div>
                <p>"Los tratamientos faciales son de otro nivel. Después de solo tres sesiones, mi piel está completamente transformada. Recomiendo Glow & Beauty al 100%."</p>
                <div class="client-name">Camila Rodríguez</div>
                <div class="client-role">Cliente Regular</div>
            </div>
            <div class="testimonial-card">
                <div class="stars">
                    <i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star-half-alt"></i>
                </div>
                <p>"Me maquillaron para mi boda y el resultado fue espectacular. Duró toda la noche y las fotos salieron increíbles. ¡Gracias por hacerme sentir una princesa!"</p>
                <div class="client-name">Ana Patricia Gómez</div>
                <div class="client-role">Novia Feliz</div>
            </div>
        </div>
    </section>

    <!-- CTA -->
    <section class="cta-section">
        <h2>¿Lista para tu Transformación?</h2>
        <p>Reserva tu cita hoy y recibe un 20% de descuento en tu primer tratamiento</p>
        <a href="login.jsp" class="btn-primary">Agendar Ahora</a>
    </section>

    <!-- FOOTER -->
    <footer class="footer" id="contacto">
        <div class="footer-grid">
            <div class="footer-col">
                <h4><i class="fas fa-spa"></i> Glow & Beauty</h4>
                <p>Tu centro de belleza de confianza donde la elegancia y el bienestar se encuentran. Más de 10 años transformando vidas.</p>
                <div class="social-links">
                    <a href="#"><i class="fab fa-facebook-f"></i></a>
                    <a href="#"><i class="fab fa-instagram"></i></a>
                    <a href="#"><i class="fab fa-tiktok"></i></a>
                    <a href="#"><i class="fab fa-whatsapp"></i></a>
                </div>
            </div>
            <div class="footer-col">
                <h4>Servicios</h4>
                <a href="#">Estilismo & Corte</a><br>
                <a href="#">Manicure & Pedicure</a><br>
                <a href="#">Faciales & Spa</a><br>
                <a href="#">Maquillaje Profesional</a><br>
                <a href="#">Masajes Terapéuticos</a>
            </div>
            <div class="footer-col">
                <h4>Horario</h4>
                <p>Lunes - Viernes: 9:00 AM - 8:00 PM</p>
                <p>Sábados: 10:00 AM - 6:00 PM</p>
                <p>Domingos: 10:00 AM - 4:00 PM</p>
            </div>
            <div class="footer-col">
                <h4>Contacto</h4>
                <p><i class="fas fa-map-marker-alt"></i> Calle Belleza #123, Centro</p>
                <p><i class="fas fa-phone"></i> +57 300 123 4567</p>
                <p><i class="fas fa-envelope"></i> info@glowandbeauty.com</p>
            </div>
        </div>
        <div class="footer-bottom">
            <p>&copy; 2026 Glow & Beauty. Todos los derechos reservados.</p>
        </div>
    </footer>

    <script>
        function toggleMenu() {
            document.getElementById('navLinks').classList.toggle('active');
        }

        // Smooth scroll
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({ behavior: 'smooth', block: 'start' });
                }
            });
        });
    </script>

</body>
</html>