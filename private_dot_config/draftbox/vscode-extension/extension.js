const vscode = require('vscode');
const fs = require('fs');
const path = require('path');
const os = require('os');

function activate(context) {
  context.subscriptions.push(
    vscode.commands.registerCommand('draftbox.newNote', async () => {
      const draftDir = path.join(os.homedir(), 'Draftbox');
      const today = new Date().toISOString().slice(0, 10);
      const dayDir = path.join(draftDir, today);
      fs.mkdirSync(dayDir, { recursive: true });

      // Reuse existing empty draft
      const allDirs = fs.readdirSync(draftDir, { withFileTypes: true })
        .filter(d => d.isDirectory() && /^\d{4}-\d{2}-\d{2}$/.test(d.name));
      for (const dir of allDirs) {
        const dirPath = path.join(draftDir, dir.name);
        const files = fs.readdirSync(dirPath).filter(f => f.endsWith('.md'));
        for (const file of files) {
          const filePath = path.join(dirPath, file);
          const content = fs.readFileSync(filePath, 'utf8').trim();
          if (content === '') {
            const doc = await vscode.workspace.openTextDocument(filePath);
            await vscode.window.showTextDocument(doc, { preview: false });
            return;
          }
        }
      }

      // Find next available number
      let n = 1;
      while (fs.existsSync(path.join(dayDir, `untitled_${n}.md`))) {
        n++;
      }
      const filePath = path.join(dayDir, `untitled_${n}.md`);
      fs.writeFileSync(filePath, '');

      const doc = await vscode.workspace.openTextDocument(filePath);
      await vscode.window.showTextDocument(doc, { preview: false });
    })
  );
}

function deactivate() {}

module.exports = { activate, deactivate };
