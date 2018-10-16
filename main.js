const electron = require('electron')
// Module to control application life.
const app = electron.app
// Module to create native browser window.
const BrowserWindow = electron.BrowserWindow

const path = require('path')
const url = require('url')
const {ipcMain} = require('electron')

// Keep a global reference of the window object, if you don't, the window will
// be closed automatically when the JavaScript object is garbage collected.
let mainWindow,videoWindow

function createMainWindow () {
  // Create the browser window.
  mainWindow = new BrowserWindow({width: 800, height: 600})

  // and load the index.html of the app.
  mainWindow.loadURL(url.format({
    pathname: path.join(__dirname, 'PlaybackControlsReskin.html'),
    protocol: 'file:',
    slashes: true
  }))

  // Open the DevTools.
  //mainWindow.webContents.openDevTools()

  // Emitted when the window is closed.
  mainWindow.on('closed', function () {
    // Dereference the window object, usually you would store windows
    // in an array if your app supports multi windows, this is the time
    // when you should delete the corresponding element.
    mainWindow = null
  })
}

function createVideoWindow () {
  // Create the browser window.
  videoWindow = new BrowserWindow({width: 800, height: 600, frame:false, autoHideMenuBar:true})

  // and load the index.html of the app.
  videoWindow.loadURL(url.format({
    pathname: path.join(__dirname, 'OutputWindow.html'),
    protocol: 'file:',
    slashes: true
  }))

  // Open the DevTools.
  //videoWindow.webContents.openDevTools()

  // Emitted when the window is closed.
  videoWindow.on('closed', function () {
    // Dereference the window object, usually you would store windows
    // in an array if your app supports multi windows, this is the time
    // when you should delete the corresponding element.
    videoWindow = null
  })
}

// This method will be called when Electron has finished
// initialization and is ready to create browser windows.
// Some APIs can only be used after this event occurs.
app.on('ready', createMainWindow)
app.on('ready', createVideoWindow)

ipcMain.on('asynchronous-message', (event, arg) => {
  console.log(arg)  // prints "ping"
  videoWindow.send('asynchronous-reply', 'pong')
})

ipcMain.on('video-load', (event, arg) => {
  console.log(arg)  // prints "ping"
  videoWindow.send('video-load', arg)
  //event.sender.send('asynchronous-reply', 'pong')
})

ipcMain.on('stage-video', (event, arg) => {
  videoWindow.send('stage-video', arg)
})

ipcMain.on('pause-playback', (event, arg) => {
  videoWindow.send('pause-playback', arg)
})

ipcMain.on('play', (event, arg) => {
  videoWindow.send('play', arg)
})

ipcMain.on('request-video', (event, arg) => {
  mainWindow.send('request-video', arg)
})

ipcMain.on('effect-params', (event, arg) => {
  mainWindow.send('effect-params', arg)
})

ipcMain.on('change-effect', (event, arg) => {
  videoWindow.send('change-effect', arg)
})

ipcMain.on('video-param', (event, arg) => {
  console.log('param:' +arg)  // prints "ping"
  if(arg.fullscreen == true)
    {
      //videoWindow.setFullScreen(true)
    }
  videoWindow.send('video-param', arg)

  //event.sender.send('asynchronous-reply', 'pong')
})

ipcMain.on('synchronous-message', (event, arg) => {
  console.log(arg)  // prints "ping"
  event.returnValue = 'pong'
})

// Quit when all windows are closed.
app.on('window-all-closed', function () {
  // On OS X it is common for applications and their menu bar
  // to stay active until the user quits explicitly with Cmd + Q
  if (process.platform !== 'darwin') {
    app.quit()
  }
})

app.on('activate', function () {
  // On OS X it's common to re-create a window in the app when the
  // dock icon is clicked and there are no other windows open.
  if (mainWindow === null) {
    createMainWindow()
  }
  if (videoWindow === null) {
    createVideoWindow()
  }
})

// In this file you can include the rest of your app's specific main process
// code. You can also put them in separate files and require them here.
