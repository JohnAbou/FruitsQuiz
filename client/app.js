const { app, BrowserWindow, ipcMain, screen, globalShortcut } = require('electron');
const path = require('path');

let appWindow;
let chatWindow;

function createMainWindow() {
    const { width, height } = screen.getPrimaryDisplay().workAreaSize;
    
    appWindow = new BrowserWindow({
        autoHideMenuBar: true,
        width: width,
        height: height,
        fullscreen: true,
        resizable: false,
        movable: false,
        webPreferences: {
            nodeIntegration: true,
            contextIsolation: false,
            // devTools: false,        TODO DECOMMENTER CETTE LIGNE POUR LA REMISE
        },
        icon: path.join(__dirname, 'src/assets/lemonIcon.ico')
        
    });
    appWindow.loadFile(path.join(__dirname, 'build', 'index.html'));

    appWindow.on('closed', function () {
        if (chatWindow) {
            chatWindow.close();
        }
        appWindow = null;
    });
    
    appWindow.webContents.on('before-input-event', (event, input) => {
        blockKeys(event, input);
    });
}

function createChatWindow(username, sessionId, chats, gameId, selectedChat, userPreference) {
    if (chatWindow) {
        chatWindow.focus();
        return;
    }

    chatWindow = new BrowserWindow({
        width: 500,
        height: 750,
        autoHideMenuBar: true,
        resizable: false,
        webPreferences: {
            nodeIntegration: true,
            contextIsolation: false,
            // devTools: false,        TODO DECOMMENTER CETTE LIGNE POUR LA REMISE
        },
    });

    chatWindow.loadFile(path.join(__dirname, 'build', 'index.html'), { hash: '/chat' });


    ipcMain.on('selected-chat-changed', (event, chatId) => {
        lastSelectedChatId = chatId;
      });

    chatWindow.on('closed', () => {
        chatWindow = null;
        if (appWindow) {
            appWindow.webContents.send('chat-window-closed', { selectedChatId: lastSelectedChatId });
        }
    });
    
    ipcMain.on('theme-changed', (event, data) => {
        if (chatWindow && chatWindow.webContents) {
          chatWindow.webContents.send('theme-changed', data);
        }
      });

      ipcMain.on('language-changed', (event, data) => {
        if (chatWindow && chatWindow.webContents) {
          chatWindow.webContents.send('language-changed', data);
           }
        });

    chatWindow.webContents.on('before-input-event', (event, input) => {
        blockKeys(event, input);
    });

    chatWindow.webContents.once('did-finish-load', () => {
        chatWindow.webContents.send('chat-data', { username, sessionId, chats, gameId, selectedChat, userPreference });
        chatWindow.setTitle('Fruits Chat');
    });

}

app.whenReady().then(() => {
    createMainWindow();

    ipcMain.on('initialize-chats', (event, data) => {
        if (chatWindow && chatWindow.webContents) {
            chatWindow.webContents.send('initialize-chats', data);
        }
    });

    ipcMain.on('open-chat-window', (event, data) => {
        const username = data?.username;
        const chats = data?.chats;
        const sessionId = data?.sessionId;
        const gameId = data?.gameId;
        const selectedChat = data?.selectedChat;
        const userPreference = data?.userPreference;
        createChatWindow(username, sessionId, chats, gameId, selectedChat, userPreference);
    });

    ipcMain.on('open-profile-in-main', (event, data) => {
        if (appWindow && appWindow.webContents) {
            appWindow.webContents.send('open-profile-modal', data);
        }
    });

    ipcMain.on('username-changed', (event, data) => {
        if (chatWindow && chatWindow.webContents) {
            chatWindow.webContents.send('username-changed', data);
        }
    });

    ipcMain.on('left-game', (event, data) => {
        if (chatWindow && chatWindow.webContents) {
            chatWindow.webContents.send('left-game', data);
        }
    });

    ipcMain.on('add-game-chat', (event, data) => {
        if (chatWindow && chatWindow.webContents) {
            chatWindow.webContents.send('game-chat-add', data.chats);
        }
    });

    ipcMain.on('clean-up-friend-only-chats', (event, data) => {
        if (chatWindow && chatWindow.webContents) {
            chatWindow.webContents.send('clean-up-friend-only-chats', data);
        }
    });

    ipcMain.on('disconnect', () => {
        if (chatWindow && chatWindow.webContents) {
            chatWindow.close();
        }
    });

    app.on('activate', () => {
        if (BrowserWindow.getAllWindows().length === 0) {
            createMainWindow();
        }
    });
});

app.on('window-all-closed', () => {
    if (process.platform !== 'darwin') {
        app.quit();
    }
});

ipcMain.on('quit-app', () => {
    app.quit();
  });

app.on('will-quit', () => {
    globalShortcut.unregisterAll();
});



function blockKeys(event, input){
    if (input.key.match(/^F\d+$/)) {
        if (input.key === 'F4') {
            return;
        }
        event.preventDefault();
        return;
    }
    if (input.key === 'Alt') {
        if (input.type === 'keyDown') {
            return
        }
        else {
            event.preventDefault();
            return;
        }
    }
    if (input.key === 'Control' || input.ctrlKey) {
        event.preventDefault();
        return;
    }
    if (input.key === 'Shift' || input.shiftKey ) {
        event.preventDefault();
        return;
    }
}