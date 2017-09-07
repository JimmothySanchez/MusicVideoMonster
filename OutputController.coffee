$(document).ready(()->
    ipcRenderer = require('electron')
    fadeOutTime = 2

    init = ()->
        dostuff =1

    $('#video').on("timeupdate",()->
        dostuff =1
    )
)


    # <script>
    #     $(document).ready(function () {
    #         const {ipcRenderer} = require('electron')
    #         var video, canvas, seriously, reformat;
    #         const fadeOutTime = 2;

    #         $("#video").on("timeupdate", function (event) {
    #             onTrackedVideoFrame(this.currentTime, this.duration);
    #         });

    #         function init() {
    #             video = $('#video');
    #             video[0].playbackRate = 1;
    #             canvas = $('#canvas');
    #             seriously = new Seriously();
    #             reformat = seriously.transform('reformat');
    #             var target = seriously.target('#canvas');
    #             reformat.width = target.width;
    #             reformat.height = target.height;
    #             reformat.mode = 'cover';
    #             reformat.source = seriously.source('#video');
    #             target.source = reformat;

    #             $('#btnFullscreen').click(function(){
    #                 canvas[0].webkitRequestFullScreen(Element.ALLOW_KEYBOARD_INPUT);
    #             });

    #             seriously.go();
    #         }

    #         function effect_ascii(invar, outvar) {
    #             var ascii = seriously.effect('ascii');
    #             ascii.source = invar;
    #             outvar.source = ascii;
    #         }

    #         function effect_pixel(invar, outvar) {
    #             var pixel = seriously.effect('pixelate');
    #             pixel.source = invar;
    #             outvar.source = pixel;
    #         }

    #         function effect_none(invar, outvar) {
    #             outvar.source = invar;
    #         }

    #         function effect_tvglitch(invar, outvar) {
    #             var effect = seriously.effect('tvglitch');
    #             effect.source = invar;
    #             outvar.source = effect;
    #         }

    #         function effect_filmgrain(invar, outvar) {
    #             var effect = seriously.effect('filmgrain');
    #             effect.source = invar;
    #             outvar.source = effect;
    #         }

    #         function effect_invert(invar, outvar) {
    #             var effect = seriously.effect('invert');
    #             effect.source = invar;
    #             outvar.source = effect;
    #         }

    #         function effect_accumulator(invar, outvar) {
    #             console.log('accumulator effect')
    #             var effect = seriously.effect('accumulator');
    #             effect.source = invar;
    #             effect.opacity = .5;
    #             effect.blendMode = "normal";
    #             outvar.source = effect;
    #         }

    #         ipcRenderer.on('video-param', (event, arg) => {
    #             console.log(arg);
    #             if (arg.fullscreen == true) {
    #                 full()
    #             }
    #             if (arg.effect != null) {
    #                 switch (arg.effect.type) {
    #                     case "ascii":
    #                         effect_ascii(seriously.source('#video'), reformat);
    #                         break;
    #                     case "pixel":
    #                         effect_pixel(seriously.source('#video'), reformat);
    #                         break;
    #                     case "tvglitch":
    #                         effect_tvglitch(seriously.source('#video'), reformat);
    #                         break;
    #                     case "accumulator":
    #                         effect_accumulator(seriously.source('#video'), reformat);
    #                         break;
    #                     case "filmgrain":
    #                         effect_filmgrain(seriously.source('#video'), reformat);
    #                         break;
    #                     case "invert":
    #                         effect_invert(seriously.source('#video'), reformat);
    #                         break;
    #                     default:
    #                         effect_none(seriously.source('#video'), reformat);
    #                 }

    #             }
    #         })


    #         ipcRenderer.on('video-load', (event, arg) => {
    #             var abspath = 'G:\\Projects\\YoutubeDownload\\' + arg
    #             console.log(abspath) // prints "pong"
    #             //var video = document.getElementById('video');
    #             video[0].src = abspath
    #             console.log(video)
    #             video[0].load();
    #             video[0].addEventListener("canplaythrough",function(){
    #                 this.play();
    #             });
    #         })

    #         ipcRenderer.on('asynchronous-reply', (event, arg) => {
    #             console.log(arg) // prints "pong"
    #         })

    #         function onTrackedVideoFrame(currentTime, duration) {
    #             $("#current").text(currentTime);
    #             $("#duration").text(duration);
    #             if(duration-currentTime<=fadeOutTime)
    #             {
    #                 ipcRenderer.send('request-video', true);
    #             }
    #         }
    #         init();
    #     });
    # </script>