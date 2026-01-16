import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const AmadeusApp());
}

class AmadeusApp extends StatefulWidget {
  const AmadeusApp({super.key});

  @override
  State<AmadeusApp> createState() => _AmadeusAppState();
}

class _AmadeusAppState extends State<AmadeusApp> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Amadeus',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        primaryColor: const Color(0xFFD4AF37), // Золотой цвет
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A1A1A), // Темный фон
          foregroundColor: Color(0xFFD4AF37), // Золотой текст
          elevation: 0,
          centerTitle: true,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.amber,
        primaryColor: const Color(0xFFD4AF37),
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF000000),
          foregroundColor: Color(0xFFD4AF37),
          elevation: 0,
          centerTitle: true,
        ),
        useMaterial3: true,
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: WebViewScreen(
        onThemeChanged: (isDark) {
          setState(() {
            _isDarkMode = isDark;
          });
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WebViewScreen extends StatefulWidget {
  final Function(bool)? onThemeChanged;
  
  const WebViewScreen({super.key, this.onThemeChanged});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;
  final String _websiteUrl = 'https://ama-deus.com';
  bool _isLoading = true;
  double _progress = 0.0;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'FlutterChannel',
        onMessageReceived: (JavaScriptMessage message) {
          final data = message.message;
          if (data == 'login') {
            _triggerLogin();
          } else if (data == 'register') {
            _triggerRegister();
          } else if (data == 'toggleTheme') {
            _toggleTheme();
          } else if (data == 'toggleLanguage') {
            _toggleLanguage();
          }
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
              _progress = 0.0;
            });
          },
          onProgress: (int progress) {
            setState(() {
              _progress = progress / 100.0;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
              _progress = 1.0;
            });
          },
          onWebResourceError: (WebResourceError error) {
            _showErrorDialog();
          },
          onNavigationRequest: (NavigationRequest request) {
            final url = request.url;
            
            // Разрешаем навигацию по основному сайту
            if (url.contains('ama-deus.com') || url.startsWith('javascript:')) {
              return NavigationDecision.navigate;
            }
            
            // Обработка специальных протоколов
            if (url.startsWith('tel:') || 
                url.startsWith('mailto:') || 
                url.startsWith('sms:') ||
                url.startsWith('whatsapp:')) {
              _launchUrl(url);
              return NavigationDecision.prevent;
            }
            
            // Внешние ссылки открываем в браузере
            _openInBrowser(url);
            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(Uri.parse(_websiteUrl));
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      _showSnackBar('Не удалось открыть ссылку');
    }
  }

  Future<void> _openInBrowser(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _showSnackBar('Не удалось открыть в браузере');
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ошибка загрузки'),
        content: const Text('Не удалось загрузить страницу. Проверьте подключение к интернету.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _controller.reload();
            },
            child: const Text('Повторить'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _shareUrl() {
    Share.share(_websiteUrl, subject: 'Amadeus');
  }

  void _goHome() {
    _controller.loadRequest(Uri.parse(_websiteUrl));
  }

  void _reload() {
    _controller.reload();
  }

  Future<void> _openInExternalBrowser() async {
    await _openInBrowser(_websiteUrl);
  }

  void _triggerLogin() {
    _controller.runJavaScript('''
      (function() {
        var loginBtn = document.querySelector('a[href*="login"], button[onclick*="login"], .login-btn, #login, [class*="login"]');
        if (loginBtn) {
          loginBtn.click();
        } else {
          window.location.href = window.location.origin + '/login';
        }
      })();
    ''');
  }

  void _triggerRegister() {
    _controller.runJavaScript('''
      (function() {
        var registerBtn = document.querySelector('a[href*="register"], a[href*="signup"], button[onclick*="register"], .register-btn, #register, [class*="register"]');
        if (registerBtn) {
          registerBtn.click();
        } else {
          window.location.href = window.location.origin + '/register';
        }
      })();
    ''');
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    widget.onThemeChanged?.call(_isDarkMode);
    
    // Также попробуем переключить тему на сайте
    _controller.runJavaScript('''
      (function() {
        document.body.classList.toggle('dark-mode');
        var themeBtn = document.querySelector('[class*="theme"], [id*="theme"], button[onclick*="theme"]');
        if (themeBtn) themeBtn.click();
      })();
    ''');
  }

  void _toggleLanguage() {
    _controller.runJavaScript('''
      (function() {
        var langBtn = document.querySelector('[class*="lang"], [id*="lang"], button[onclick*="lang"], select[name*="lang"]');
        if (langBtn) {
          if (langBtn.tagName === 'SELECT') {
            var options = langBtn.options;
            var currentIndex = langBtn.selectedIndex;
            langBtn.selectedIndex = (currentIndex + 1) % options.length;
            langBtn.dispatchEvent(new Event('change'));
          } else {
            langBtn.click();
          }
        }
      })();
    ''');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFD4AF37),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFD4AF37).withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: const Icon(
                Icons.castle,
                color: Color(0xFF1A1A1A),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'AMADEUS',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home_rounded),
            onPressed: _goHome,
            tooltip: 'Главная',
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _reload,
            tooltip: 'Обновить',
          ),
          IconButton(
            icon: const Icon(Icons.share_rounded),
            onPressed: _shareUrl,
            tooltip: 'Поделиться',
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded),
            onSelected: (value) {
              switch (value) {
                case 'browser':
                  _openInExternalBrowser();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'browser',
                child: Row(
                  children: [
                    Icon(Icons.open_in_browser, size: 20),
                    SizedBox(width: 12),
                    Text('Открыть в браузере'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading && _progress < 1.0)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: LinearProgressIndicator(
                value: _progress,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFD4AF37)),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBottomButton(
                icon: Icons.login_rounded,
                label: 'Вход',
                onPressed: _triggerLogin,
                theme: theme,
              ),
              _buildBottomButton(
                icon: Icons.person_add_rounded,
                label: 'Регистрация',
                onPressed: _triggerRegister,
                theme: theme,
              ),
              _buildBottomButton(
                icon: Icons.language_rounded,
                label: 'Язык',
                onPressed: _toggleLanguage,
                theme: theme,
              ),
              _buildBottomButton(
                icon: _isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                label: 'Тема',
                onPressed: _toggleTheme,
                theme: theme,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required ThemeData theme,
  }) {
    final isDark = theme.brightness == Brightness.dark;
    
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4AF37).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xFFD4AF37),
                    size: 22,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.grey[300] : Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
