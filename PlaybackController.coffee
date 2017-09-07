app = angular.module('Monster-App',[])
{ipcRenderer} = require('electron')

app.controller('PlaybackController',($scope)->

    fs = require("fs")

    $scope.fileList = new Array()
    $scope.Test = "This is stills a test"

    $scope.fullScreen = ()->
        console.log('send param')
        ipcRenderer.send('video-param', JSON.parse('{"fullscreen":true}'))

    $scope.Clearlist= ()->
         $scope.fileList = new Array();

    $scope.addRecord = (path)->
        tempRecord = {"Name":path.split('/').pop(),"Path":path}
        $scope.fileList.push(tempRecord)

    $scope.loadfileList = ()->
        $scope.Clearlist()
        ##fs.readdir('Media', (err, dir) =>
        fs.readdir('G:\\Projects\\YoutubeDownload', (err, dir) =>
            angular.forEach(dir, (value,key)->
                $scope.addRecord(value);
            )
        )
        console.log($scope.fileList)

    $scope.sendEffect = (name)->
        param = 
            effect:
                type:name
        ipcRenderer.send('video-param',param)
    

    $scope.manualpush = ()->
        $scope.fileList.push('yo')

    $scope.LoadVideo = (FilePath)->
        ipcRenderer.send('video-load', FilePath)

    ipcRenderer.on('request-video', (event, arg) => {
                ipcRenderer.send('stage-video', $scope.fileList[33])
            })
)