import 'dart:io';

import 'package:app_logging/app_logging.dart';
import 'package:path/path.dart' as p;

/// Generates HTML index files for the documentation server.
class IndexGenerator {
  const IndexGenerator._();

  /// Creates a dynamic index.html with package listing.
  ///
  /// [docsDir] is the root directory containing package documentation.
  /// [entities] is the list of file system entities in the directory.
  static Future<void> createDynamicIndex(
    Directory docsDir,
    List<FileSystemEntity> entities,
  ) async {
    try {
      final packageDirs = entities.whereType<Directory>().toList();

      AppLogging.logServerOperation(
          'Creating dynamic index with ${packageDirs.length} packages');

      final indexFile = File('${docsDir.path}/index.html');

      final packageListHtml = packageDirs.map((dir) {
        final packageName = p.basename(dir.path);
        return '''
          <div class="package-card" onclick="location.href='./$packageName/'">
            <div class="package-icon">📦</div>
            <div class="package-info">
              <h3>$packageName</h3>
              <p>Click to browse documentation</p>
            </div>
            <div class="package-arrow">→</div>
          </div>''';
      }).join('\n');

      final htmlContent = '''
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hex Documentation Server - Available Packages</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 2rem;
            color: #333;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
        }
        .header {
            text-align: center;
            margin-bottom: 3rem;
            color: white;
        }
        .header h1 {
            font-size: 2.5rem;
            margin-bottom: 1rem;
            font-weight: 700;
        }
        .header p {
            font-size: 1.2rem;
            opacity: 0.9;
        }
        .stats {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            text-align: center;
            color: white;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        .stats h2 {
            margin-bottom: 0.5rem;
        }
        .package-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }
        .package-card {
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 1rem;
        }
        .package-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
        }
        .package-icon {
            font-size: 2rem;
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-radius: 12px;
            padding: 0.5rem;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .package-info {
            flex: 1;
        }
        .package-info h3 {
            color: #2c3e50;
            margin-bottom: 0.5rem;
            font-size: 1.2rem;
        }
        .package-info p {
            color: #7f8c8d;
            font-size: 0.9rem;
        }
        .package-arrow {
            font-size: 1.5rem;
            color: #667eea;
            font-weight: bold;
        }
        .no-packages {
            text-align: center;
            background: rgba(255, 255, 255, 0.9);
            border-radius: 15px;
            padding: 3rem;
            margin: 2rem 0;
        }
        .no-packages h2 {
            color: #2c3e50;
            margin-bottom: 1rem;
        }
        .no-packages p {
            color: #7f8c8d;
            margin-bottom: 1rem;
        }
        .instructions {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 2rem;
            margin-top: 2rem;
            color: white;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        .instructions h3 {
            margin-bottom: 1rem;
        }
        .instructions ul {
            list-style: none;
            padding: 0;
        }
        .instructions li {
            margin-bottom: 0.5rem;
            padding-left: 1.5rem;
            position: relative;
        }
        .instructions li:before {
            content: "✓";
            position: absolute;
            left: 0;
            color: #4CAF50;
            font-weight: bold;
        }
        @media (max-width: 768px) {
            body { padding: 1rem; }
            .header h1 { font-size: 2rem; }
            .package-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>📚 Hex Documentation Server</h1>
            <p>Your offline documentation is ready to browse!</p>
        </div>

        <div class="stats">
            <h2>${packageDirs.length} Packages Available</h2>
            <p>Click on any package to browse its documentation</p>
        </div>

        <div class="package-grid">
            $packageListHtml
        </div>

        <div class="instructions">
            <h3>💡 How to use this server:</h3>
            <ul>
                <li>Click on any package card to browse its documentation</li>
                <li>Navigate through different versions using the directory browser</li>
                <li>Bookmark this page for quick access to your offline docs</li>
                <li>The server automatically detects new packages you download</li>
            </ul>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            console.log('Hex Documentation Server loaded with ${packageDirs.length} packages');

            document.querySelectorAll('.package-card').forEach(card => {
                card.addEventListener('click', function() {
                    console.log('Navigating to package:', this.querySelector('h3').textContent);
                });
            });
        });
    </script>
</body>
</html>''';

      await indexFile.writeAsString(htmlContent);
      AppLogging.logServerOperation(
          'Created dynamic index.html with ${packageDirs.length} packages');

      if (await indexFile.exists() && await indexFile.length() > 0) {
        AppLogging.logServerOperation(
            'Dynamic index file verified: ${await indexFile.length()} bytes');
      } else {
        throw Exception('Dynamic index file was not created properly');
      }
    } catch (e) {
      AppLogging.logServerError('Failed to create dynamic index file', e);
      await createDefaultIndex(docsDir);
    }
  }

  /// Creates a default index.html welcome page.
  ///
  /// [docsDir] is the root directory containing package documentation.
  static Future<void> createDefaultIndex(Directory docsDir) async {
    try {
      final indexFile = File('${docsDir.path}/index.html');

      if (!await indexFile.exists()) {
        const htmlContent = '''<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hex Documentation Server</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 2rem;
            line-height: 1.6;
            color: #333;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .container {
            text-align: center;
            background: white;
            padding: 3rem;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            max-width: 600px;
            width: 100%;
        }
        .logo {
            font-size: 4rem;
            margin-bottom: 1.5rem;
            animation: bounce 2s infinite;
        }
        @keyframes bounce {
            0%, 20%, 50%, 80%, 100% { transform: translateY(0); }
            40% { transform: translateY(-10px); }
            60% { transform: translateY(-5px); }
        }
        h1 {
            color: #2c3e50;
            margin-bottom: 1rem;
            font-size: 2.5rem;
            font-weight: 700;
        }
        .info {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 2rem;
            border-radius: 15px;
            margin: 2rem 0;
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
        }
        .info h3 {
            margin-bottom: 1rem;
            font-size: 1.5rem;
        }
        .info p {
            margin-bottom: 0.5rem;
            opacity: 0.9;
        }
        .placeholder {
            background: #f8f9fa;
            color: #6c757d;
            padding: 2rem;
            border-radius: 15px;
            margin: 2rem 0;
            border: 2px dashed #dee2e6;
        }
        .placeholder p {
            margin-bottom: 1rem;
            font-size: 1.1rem;
        }
        .status {
            background: #e8f5e8;
            color: #28a745;
            padding: 1rem;
            border-radius: 10px;
            margin: 1rem 0;
            border-left: 4px solid #28a745;
            font-weight: 600;
        }
        .url-display {
            background: #2c3e50;
            color: #fff;
            padding: 1rem;
            border-radius: 10px;
            font-family: 'Courier New', monospace;
            font-size: 1.1rem;
            margin: 1rem 0;
            word-break: break-all;
            box-shadow: inset 0 2px 4px rgba(0,0,0,0.1);
        }
        .features {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1rem;
            margin: 2rem 0;
        }
        .feature {
            background: white;
            padding: 1.5rem;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            border-left: 4px solid #667eea;
        }
        .feature h4 {
            color: #2c3e50;
            margin-bottom: 0.5rem;
        }
        .feature p {
            color: #6c757d;
            font-size: 0.9rem;
        }
        @media (max-width: 768px) {
            body { padding: 1rem; }
            .container { padding: 2rem; }
            h1 { font-size: 2rem; }
            .logo { font-size: 3rem; }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="logo">📚</div>
        <h1>Hex Documentation Server</h1>

        <div class="status">
            ✅ Server is running successfully!
        </div>

        <div class="info">
            <h3>🎉 Welcome to your Hex documentation server!</h3>
            <p>Your server is up and running, ready to serve Hex package documentation.</p>
            <div class="url-display">
                <strong>Server URL:</strong> <span id="server-url"></span>
            </div>
        </div>

        <div class="placeholder">
            <p>📦 <strong>No Hex documentation files found yet?</strong></p>
            <p>Don't worry! This is normal when you first start the server.</p>
            <p>🌐 <strong>Next steps:</strong></p>
        </div>

        <div class="features">
            <div class="feature">
                <h4>📥 Download Docs</h4>
                <p>Go to the Downloads tab in the app and download Hex package documentation</p>
            </div>
            <div class="feature">
                <h4>🔍 Browse Content</h4>
                <p>Navigate through packages and versions using the server's directory browsing</p>
            </div>
            <div class="feature">
                <h4>📖 View Offline</h4>
                <p>Access documentation files offline through this server URL</p>
            </div>
            <div class="feature">
                <h4>⚡ Quick Access</h4>
                <p>Perfect for offline Hex package documentation viewing on mobile devices</p>
            </div>
        </div>

        <div class="info">
            <h3>💡 Pro Tips:</h3>
            <p>• Use the server's directory browsing to explore available packages</p>
            <p>• Bookmark this URL for quick access to your offline documentation</p>
            <p>• The server automatically detects and serves downloaded Hex docs</p>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const serverUrl = window.location.origin;
            const urlElement = document.getElementById('server-url');
            if (urlElement) {
                urlElement.textContent = serverUrl;
            }

            document.body.style.visibility = 'visible';

            console.log('Hex Documentation Server loaded successfully');
            console.log('Server URL:', serverUrl);
        });
    </script>
</body>
</html>''';

        await indexFile.writeAsString(htmlContent);
        AppLogging.logServerOperation(
            'Created default index.html file with welcome page');

        if (await indexFile.exists() && await indexFile.length() > 0) {
          AppLogging.logServerOperation(
              'Index file verified: ${await indexFile.length()} bytes');
        } else {
          throw Exception('Index file was not created properly');
        }
      } else {
        AppLogging.logServerOperation(
            'Index file already exists, skipping creation');
      }
    } catch (e) {
      AppLogging.logServerError('Failed to create default index.html file', e);
      throw Exception('Failed to create server index file: $e');
    }
  }
}
