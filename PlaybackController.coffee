app = angular.module('Monster-App',['dndLists'])
{ipcRenderer} = require('electron')

app.controller('PlaybackController',($scope)->

    fs = require("fs")
    $scope.selectedVideo = null
    $scope.fileList = []
    $scope.Test = "This is stills a test"

    $scope.fullScreen = ()->
        console.log('send param')
        ipcRenderer.send('video-param', JSON.parse('{"fullscreen":true}'))

    $scope.Clearlist= ()->
         $scope.fileList = []

    $scope.addRecord = (path)->
        tempRecord = {"Name":path.split('/').pop(),"Path":path}
        $scope.fileList.push(tempRecord)

    $scope.loadfileList = ()->
        $scope.Clearlist()
        ##$scope.fileList.push({"Name":i,"Path":i}) for i in [1..10]
        fs.readdir('G:\\Projects\\YoutubeDownload', (err, dir) =>
            angular.forEach(dir, (value,key)->
                $scope.addRecord(value);
            )
        )


    $scope.sendEffect = (name)->
        param = 
            effect:
                type:name
        ipcRenderer.send('video-param',param)
    

    $scope.manualpush = ()->
        $scope.fileList.push('yo')

    $scope.LoadVideo = (FilePath)->
        ipcRenderer.send('stage-video', FilePath)

    $scope.test =()->
        console.log('test')

    $scope.save=()->
        try
            fs.writeFileSync('MonsterSave.txt', angular.toJson($scope.fileList, true), 'utf-8')
        catch e
            console.log(e)
            alert('Failed to save the file !')

    ipcRenderer.on('request-video', (event, arg) =>
        ipcRenderer.send('stage-video', $scope.fileList[33])
    )
)