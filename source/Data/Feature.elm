module Data.Feature
    exposing
        ( Feature
        , all
        , imgUrl
        )

import Data.Config exposing (Config)


{-| Feature, as in, a feature in the CtPaint
drawing application.
-}
type alias Feature =
    { name : String
    , description : String
    , img : String
    }


all : List Feature
all =
    [ zoomOut
    , invert
    , undoAndRedo
    , clipboard
    , resize
    , scale
    , urlImport
    , replaceColor
    , sample
    , zoomIn
    , transparency
    , rectangle
    , rectangleFilled
    , minimap
    , colorPicker
    , line
    , download
    , upload
    , text
    , hand
    , select
    , pencil
    , rotateAndFlip
    , fill
    , eraser
    ]


sample : Feature
sample =
    { name = "sample"
    , description =
        """
        By clicking on a specific pixel, you can
        add that color to your swatches. The icon
        is that of a eye dropper.
        """
    , img = "sample"
    }


download : Feature
download =
    { name = "download"
    , description =
        """
        You can download your image right from
        CtPaint to your computer.
        """
    , img = "download"
    }


upload : Feature
upload =
    { name = "upload"
    , description =
        """
        You can upload files from your computer
        into CtPaint.
        """
    , img = "upload"
    }


text : Feature
text =
    { name = "text"
    , description =
        """
        In the text menu, you can type in whatever
        text you would like, and then add it to
        your canvas.
        """
    , img = "text"
    }


transparency : Feature
transparency =
    { name = "transparency"
    , description =
        """
        There is no true transparency in CtPaint,
        but you can set one color in your selections
        to act as transparency.
        """
    , img = "transparency"
    }


rectangleFilled : Feature
rectangleFilled =
    { name = "filled rectangle"
    , description =
        """
        Click and drag to make a filled in
        rectangle
        """
    , img = "rectangle-filled"
    }


rectangle : Feature
rectangle =
    { name = "rectangle"
    , description =
        """
        Click and drag to make the outline of
        a rectangle.
        """
    , img = "rectangle"
    }


minimap : Feature
minimap =
    { name = "minimap"
    , description =
        """
        The minimap shows you the canvas from a different
        perspective. This is useful if you are really
        zoomed into one part of the canvas, but you
        need to get a sense of what the canvas looks
        like as a whole.
        """
    , img = "minimap"
    }


colorPicker : Feature
colorPicker =
    { name = "color picker"
    , description =
        """
        You can customize the colors in your palette
        using the color picker. The color picker
        has red, green, blue, hue, saturation, and
        lightness sliders, as well as a hex code
        input.
        """
    , img = "color-picker"
    }


undoAndRedo : Feature
undoAndRedo =
    { name = "undo and redo"
    , description =
        """
        Undo a change made to the canvas,
        or redo a change. History is limited to
        15 changes.
        """
    , img = "undo-and-redo"
    }


clipboard : Feature
clipboard =
    { name = "clipboard, copy, cut, and paste"
    , description =
        """
        Copy a section of the canvas, and paste
        it somewhere else.
        """
    , img = "clipboard"
    }


rotateAndFlip : Feature
rotateAndFlip =
    { name = "rotate and flip"
    , description =
        """
        You can rotate your canvas or selection in
        increments of 90 degrees, or you can mirror
        it vertically or horizontally with the flip
        options.
        """
    , img = "rotate-and-flip"
    }


scale : Feature
scale =
    { name = "scale"
    , description =
        """
        This menu is kind of like resize, except
        that you can change the size in percentage units
        relative to your canvass existing size.
        You can also lock the width to height ratio.
        """
    , img = "scale"
    }


resize : Feature
resize =
    { name = "resize"
    , description =
        """
        This menu will let you change the size of
        your canvas or selection.
        """
    , img = "resize"
    }


replaceColor : Feature
replaceColor =
    { name = "replace color"
    , description =
        """
        This menu lets you choose a target color,
        and a replacement color, and then replace
        every instance of your chosen target color with
        your chosen replacement color.
        """
    , img = "replace-color"
    }


invert : Feature
invert =
    { name = "invert colors"
    , description =
        """
        Set all the colors in your canvas or selection,
        to their opposite. Black becomes white, red becomes
        green, gray becomes gray, etc.
        """
    , img = "invert"
    }


line : Feature
line =
    { name = "line"
    , description =
        """
        Draw a line by clicking somewhere,
        moving your mouse, and
        then clicking again. The positions of
        the first and second clicks are the
        start and end points of the line.
        """
    , img = "line"
    }


urlImport : Feature
urlImport =
    { name = "import from image url"
    , description =
        """
        If you have the url of an image, you
        can import it directly into CtPaint.
        """
    , img = "url-import"
    }


select : Feature
select =
    { name = "select"
    , description =
        """
        Click and drag to select and detach a region
        of the canvas. Once its detached, you can
        delete it, move it, or transform it.
        """
    , img = "select"
    }


hand : Feature
hand =
    { name = "hand"
    , description =
        """
        This tool is for moving either the
        whole canvas or the selection around.
        """
    , img = "hand"
    }


zoomOut : Feature
zoomOut =
    { name = "zoom out"
    , description =
        """
        Zoom out from a specific part of the canvas
        """
    , img = "zoom-out"
    }


zoomIn : Feature
zoomIn =
    { name = "zoom in"
    , description =
        """
        Zoom in to a specific part of the canvas
        """
    , img = "zoom-in"
    }


eraser : Feature
eraser =
    { name = "eraser"
    , description =
        """
        Its called "Eraser", but really its just
        a way to draw broad strokes with a square
        shaped brush. It is however useful if you
        want to erase a big area of your canvas.
        """
    , img = "eraser"
    }


fill : Feature
fill =
    { name = "fill"
    , description =
        """
        Fill a region with a certain color. Its icon
        show a pouring paint bucket.
        """
    , img = "fill"
    }


pencil : Feature
pencil =
    { name = "pencil"
    , description =
        """
        Your most basic drawing tool. If you click
        somewhere with the pencil and you will
        color that pixel.
        """
    , img = "pencil"
    }


imgUrl : Config -> Feature -> String
imgUrl { mountPath } feature =
    [ mountPath
    , "/"
    , feature.img
    , ".png"
    ]
        |> String.concat
