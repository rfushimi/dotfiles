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

      // Reuse an empty draft from today's directory only.
      const todayFiles = fs.readdirSync(dayDir).filter(f => f.endsWith('.md'));
      for (const file of todayFiles) {
        const filePath = path.join(dayDir, file);
        const content = fs.readFileSync(filePath, 'utf8').trim();
        if (content === '') {
          const doc = await vscode.workspace.openTextDocument(filePath);
          await vscode.window.showTextDocument(doc, { preview: false });
          return;
        }
      }

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
