import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf_static/shelf_static.dart';
import 'package:path/path.dart' as path;

/// Custom handler that serves static files and provides directory browsing
class DirectoryBrowserHandler {
  final String _rootPath;
  final Handler _staticHandler;

  DirectoryBrowserHandler(this._rootPath)
      : _staticHandler = createStaticHandler(
          _rootPath,
          defaultDocument: 'index.html',
        );

  /// Handle requests with directory browsing support
  Future<Response> handle(Request request) async {
    final urlPath = request.url.path;
    final fullPath = path.join(_rootPath, urlPath);
    final file = File(fullPath);
    final dir = Directory(fullPath);

    // If it's a file, try to serve it with the static handler
    if (await file.exists()) {
      return _staticHandler(request);
    }

    // If it's a directory, try to serve index.html first
    if (await dir.exists()) {
      final indexPath = path.join(fullPath, 'index.html');
      final indexFile = File(indexPath);

      if (await indexFile.exists()) {
        // Serve index.html
        return _staticHandler(Request(
          'GET',
          request.requestedUri,
          protocolVersion: request.protocolVersion,
          headers: request.headers,
          handlerPath: request.handlerPath,
          url: Uri.parse('${request.url.path == '/' ? '' : request.url.path}/index.html'),
          context: request.context,
          encoding: request.encoding,
        ));
      }

      // No index.html found, generate directory listing
      return _generateDirectoryListing(dir, urlPath);
    }

    // Not found
    return Response.notFound('File not found: ${request.url.path}');
  }

  /// Generate HTML directory listing
  Response _generateDirectoryListing(Directory dir, String urlPath) {
    try {
      final entities = dir.listSync();
      final directories = <FileSystemEntity>[];
      final files = <FileSystemEntity>[];

      // Separate directories and files
      for (final entity in entities) {
        if (entity is Directory) {
          directories.add(entity);
        } else if (entity is File) {
          files.add(entity);
        }
      }

      // Sort them
      directories.sort((a, b) => a.path.toLowerCase().compareTo(b.path.toLowerCase()));
      files.sort((a, b) => a.path.toLowerCase().compareTo(b.path.toLowerCase()));

      final html = _buildDirectoryHtml(dir, urlPath, directories, files);

      return Response.ok(
        html,
        headers: {
          'content-type': 'text/html; charset=utf-8',
          'cache-control': 'no-cache',
        },
      );
    } catch (e) {
      return Response.internalServerError(
        body: 'Error generating directory listing: $e',
      );
    }
  }

  /// Build HTML for directory listing
  String _buildDirectoryHtml(
    Directory dir,
    String urlPath,
    List<FileSystemEntity> directories,
    List<FileSystemEntity> files,
  ) {
    final parentPath = path.dirname(urlPath);
    final isRoot = urlPath.isEmpty || urlPath == '/';
    final dirName = path.basename(dir.path);

    final buffer = StringBuffer();
    buffer.writeln('<!DOCTYPE html>');
    buffer.writeln('<html lang="en">');
    buffer.writeln('<head>');
    buffer.writeln('    <meta charset="UTF-8">');
    buffer.writeln('    <meta name="viewport" content="width=device-width, initial-scale=1.0">');
    buffer.writeln('    <title>Directory listing: $dirName</title>');
    buffer.writeln('    <style>');
    buffer.writeln('        body {');
    buffer.writeln('            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;');
    buffer.writeln('            max-width: 800px;');
    buffer.writeln('            margin: 0 auto;');
    buffer.writeln('            padding: 2rem;');
    buffer.writeln('            line-height: 1.6;');
    buffer.writeln('            color: #333;');
    buffer.writeln('        }');
    buffer.writeln('        .header {');
    buffer.writeln('            text-align: center;');
    buffer.writeln('            margin-bottom: 2rem;');
    buffer.writeln('        }');
    buffer.writeln('        .breadcrumb {');
    buffer.writeln('            background: #f8f9fa;');
    buffer.writeln('            padding: 1rem;');
    buffer.writeln('            border-radius: 8px;');
    buffer.writeln('            margin-bottom: 2rem;');
    buffer.writeln('            font-family: monospace;');
    buffer.writeln('            font-size: 0.9rem;');
    buffer.writeln('        }');
    buffer.writeln('        .directory-list {');
    buffer.writeln('            list-style: none;');
    buffer.writeln('            padding: 0;');
    buffer.writeln('        }');
    buffer.writeln('        .directory-item {');
    buffer.writeln('            display: flex;');
    buffer.writeln('            align-items: center;');
    buffer.writeln('            padding: 0.75rem 1rem;');
    buffer.writeln('            border-bottom: 1px solid #eee;');
    buffer.writeln('            text-decoration: none;');
    buffer.writeln('            color: inherit;');
    buffer.writeln('            transition: background-color 0.2s;');
    buffer.writeln('        }');
    buffer.writeln('        .directory-item:hover {');
    buffer.writeln('            background-color: #f8f9fa;');
    buffer.writeln('        }');
    buffer.writeln('        .icon {');
    buffer.writeln('            margin-right: 1rem;');
    buffer.writeln('            font-size: 1.2rem;');
    buffer.writeln('            width: 24px;');
    buffer.writeln('            text-align: center;');
    buffer.writeln('        }');
    buffer.writeln('        .directory-icon { color: #007bff; }');
    buffer.writeln('        .file-icon { color: #6c757d; }');
    buffer.writeln('        .name { flex: 1; }');
    buffer.writeln('        .size {');
    buffer.writeln('            color: #6c757d;');
    buffer.writeln('            font-size: 0.9rem;');
    buffer.writeln('            margin-left: 1rem;');
    buffer.writeln('        }');
    buffer.writeln('        .modified {');
    buffer.writeln('            color: #6c757d;');
    buffer.writeln('            font-size: 0.9rem;');
    buffer.writeln('            margin-left: 1rem;');
    buffer.writeln('        }');
    buffer.writeln('        .header-text { color: #2c3e50; margin-bottom: 1rem; }');
    buffer.writeln('        .stats { color: #6c757d; font-size: 0.9rem; }');
    buffer.writeln('    </style>');
    buffer.writeln('</head>');
    buffer.writeln('<body>');
    buffer.writeln('    <div class="header">');
    buffer.writeln('        <div class="icon" style="font-size: 4rem; margin-bottom: 1rem;">📁</div>');
    buffer.writeln('        <h1 class="header-text">Directory listing: $dirName</h1>');
    buffer.writeln('        <div class="stats">');
    buffer.writeln('            ${directories.length} director${directories.length == 1 ? 'y' : 'ies'}, ${files.length} file${files.length == 1 ? '' : 's'}');
    buffer.writeln('        </div>');
    buffer.writeln('    </div>');

    // Breadcrumb navigation
    buffer.writeln('    <div class="breadcrumb">');
    buffer.writeln('        📁 ');
    if (isRoot) {
      buffer.writeln('            / (root)');
    } else {
      buffer.writeln('            <a href="/" style="text-decoration: none; color: inherit;">/ (root)</a>');
      final parts = urlPath.split('/');
      var currentPath = '';
      for (var i = 0; i < parts.length; i++) {
        if (parts[i].isEmpty) continue;
        currentPath += '/${parts[i]}';
        buffer.writeln('            / <a href="$currentPath" style="text-decoration: none; color: inherit;">${parts[i]}</a>');
      }
    }
    buffer.writeln('    </div>');

    // Parent directory link (if not root)
    if (!isRoot) {
      buffer.writeln('    <ul class="directory-list">');
      buffer.writeln('        <li>');
      buffer.writeln('            <a href="$parentPath" class="directory-item">');
      buffer.writeln('                <span class="icon directory-icon">⬆️</span>');
      buffer.writeln('                <span class="name">.. (parent directory)</span>');
      buffer.writeln('            </a>');
      buffer.writeln('        </li>');
    } else {
      buffer.writeln('    <ul class="directory-list">');
    }

    // Directories
    for (final directory in directories) {
      final dirName = path.basename(directory.path);
      final relativePath = path.join(urlPath, dirName);
      buffer.writeln('        <li>');
      buffer.writeln('            <a href="$relativePath" class="directory-item">');
      buffer.writeln('                <span class="icon directory-icon">📁</span>');
      buffer.writeln('                <span class="name">$dirName/</span>');
      buffer.writeln('                <span class="size">—</span>');
      buffer.writeln('                <span class="modified">${_formatDate(directory.statSync().modified)}</span>');
      buffer.writeln('            </a>');
      buffer.writeln('        </li>');
    }

    // Files
    for (final file in files) {
      final fileName = path.basename(file.path);
      final fileSize = file.statSync().size;
      final modified = file.statSync().modified;
      final fileIcon = _getFileIcon(fileName);
      final relativePath = path.join(urlPath, fileName);

      buffer.writeln('        <li>');
      buffer.writeln('            <a href="$relativePath" class="directory-item">');
      buffer.writeln('                <span class="icon file-icon">$fileIcon</span>');
      buffer.writeln('                <span class="name">$fileName</span>');
      buffer.writeln('                <span class="size">${_formatFileSize(fileSize)}</span>');
      buffer.writeln('                <span class="modified">${_formatDate(modified)}</span>');
      buffer.writeln('            </a>');
      buffer.writeln('        </li>');
    }

    buffer.writeln('    </ul>');
    buffer.writeln('</body>');
    buffer.writeln('</html>');

    return buffer.toString();
  }

  /// Get appropriate icon for file type
  String _getFileIcon(String fileName) {
    final extension = path.extension(fileName).toLowerCase();

    const iconMap = {
      '.html': '🌐',
      '.htm': '🌐',
      '.css': '🎨',
      '.js': '📜',
      '.json': '📋',
      '.xml': '📄',
      '.txt': '📝',
      '.md': '📝',
      '.pdf': '📕',
      '.jpg': '🖼️',
      '.jpeg': '🖼️',
      '.png': '🖼️',
      '.gif': '🖼️',
      '.svg': '🎨',
      '.ico': '🖼️',
      '.mp3': '🎵',
      '.mp4': '🎬',
      '.avi': '🎬',
      '.mov': '🎬',
      '.zip': '📦',
      '.tar': '📦',
      '.gz': '📦',
      '.doc': '📘',
      '.docx': '📘',
      '.xls': '📗',
      '.xlsx': '📗',
      '.ppt': '📙',
      '.pptx': '📙',
    };

    return iconMap[extension] ?? '📄';
  }

  /// Format file size for display
  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Format date for display
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    }
  }
}

/// Create a handler that serves static files with directory browsing support
Handler createDirectoryBrowserHandler(String rootPath) {
  final browserHandler = DirectoryBrowserHandler(rootPath);

  return (Request request) async {
    return await browserHandler.handle(request);
  };
}