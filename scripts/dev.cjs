// Static preview only. Netlify functions still require the Netlify runtime.
const http = require("node:http");
const fs = require("node:fs/promises");
const path = require("node:path");
const root = path.resolve(__dirname, "..");
const port = Number(process.env.PORT || 4173);
const types = { ".html": "text/html", ".css": "text/css", ".js": "text/javascript", ".svg": "image/svg+xml" };

http.createServer(async (req, res) => {
  try {
    const pathname = decodeURIComponent(new URL(req.url, "http://localhost").pathname);
    if (pathname.startsWith("/.netlify/")) {
      res.writeHead(501, { "Content-Type": "application/json; charset=utf-8" });
      res.end(JSON.stringify({ error: "Acest flux necesită funcțiile Netlify. Pornește proiectul cu Netlify Dev pentru integrarea completă." }));
      return;
    }
    const file = path.resolve(root, "." + (pathname === "/" ? "/index.html" : pathname));
    const relative = path.relative(root, file);
    const ext = path.extname(file);
    const allowed = /^(assets[\\/]|portal[\\/])/.test(relative) || !/[\\/]/.test(relative);
    if (relative.startsWith("..") || path.isAbsolute(relative) || !allowed || !types[ext]) {
      res.writeHead(404); res.end("Not found"); return;
    }
    const content = await fs.readFile(file);
    res.writeHead(200, { "Content-Type": types[ext] + "; charset=utf-8", "Cache-Control": "no-store", "X-Content-Type-Options": "nosniff" });
    res.end(content);
  } catch {
    res.writeHead(404); res.end("Not found");
  }
}).listen(port, "127.0.0.1", () => console.log(`Akademia: http://localhost:${port}`));
