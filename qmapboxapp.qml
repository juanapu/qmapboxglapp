import QtGraphicalEffects 1.0
import QtLocation 5.9
import QtPositioning 5.0
import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Dialogs 1.0
import QtQuick.Layouts 1.0

ApplicationWindow {
    title: "Qt Location Mapbox GL plugin"
    width: 1024
    height: 768
    visible: true

    Map {
        id: map
        anchors.fill: parent

        plugin: Plugin { name: "mapboxgl" }

        center: QtPositioning.coordinate(60.170448, 24.942046) // Helsinki
        zoomLevel: 12.25
        minimumZoomLevel: 0
        maximumZoomLevel: 20
        tilt: tiltSlider.value
        bearing: bearingSlider.value
        color: landColorDialog.color

        MapParameter {
            id: waterPaint
            property var type: "paint"
            property var layer: "water"
            property var fillColor: waterColorDialog.color
        }

        MapParameter {
            id: source
            property var type: "source"
            property var name: "routeSource"
            property var sourceType: "geojson"
            property var data: ":source1.geojson"
        }

        MapParameter {
            property var type: "layer"
            property var name: "routeCase"
            property var layerType: "line"
            property var source: "routeSource"
        }

        MapParameter {
            property var type: "paint"
            property var layer: "routeCase"
            property var lineColor: "white"
            property var lineWidth: 20.0
        }

        MapParameter {
            property var type: "layout"
            property var layer: "routeCase"
            property var lineJoin: "round"
            property var lineCap: lineJoin
            property var visibility: toggleRoute.checked ? "visible" : "none"
        }

        MapParameter {
            property var type: "layer"
            property var name: "route"
            property var layerType: "line"
            property var source: "routeSource"
        }

        MapParameter {
            id: linePaint
            property var type: "paint"
            property var layer: "route"
            property var lineColor: "blue"
            property var lineWidth: 8.0
        }

        MapParameter {
            property var type: "layout"
            property var layer: "route"
            property var lineJoin: "round"
            property var lineCap: "round"
            property var visibility: toggleRoute.checked ? "visible" : "none"
        }

        MapParameter {
            property var type: "image"
            property var name: "label-arrow"
            property var sprite: ":label-arrow.svg"
        }

        MapParameter {
            property var type: "image"
            property var name: "label-background"
            property var sprite: ":label-background.svg"
        }

        MapParameter {
            property var type: "layer"
            property var name: "markerArrow"
            property var layerType: "symbol"
            property var source: "routeSource"
        }

        MapParameter {
            property var type: "layout"
            property var layer: "markerArrow"
            property var iconImage: "label-arrow"
            property var iconSize: 0.5
            property var iconIgnorePlacement: true
            property var iconOffset: [ 0.0, -15.0 ]
            property var visibility: toggleRoute.checked ? "visible" : "none"
        }

        MapParameter {
            property var type: "layer"
            property var name: "markerBackground"
            property var layerType: "symbol"
            property var source: "routeSource"
        }

        MapParameter {
            property var type: "layout"
            property var layer: "markerBackground"
            property var iconImage: "label-background"
            property var textField: "{name}"
            property var iconTextFit: "both"
            property var iconIgnorePlacement: true
            property var textIgnorePlacement: true
            property var textAnchor: "left"
            property var textSize: 16.0
            property var textPadding: 0.0
            property var textLineHeight: 1.0
            property var textMaxWidth: 8.0
            property var iconTextFitPadding: [ 15.0, 10.0, 15.0, 10.0 ]
            property var textOffset: [ -0.5, -1.5 ]
            property var visibility: toggleRoute.checked ? "visible" : "none"
        }

        MapParameter {
            property var type: "paint"
            property var layer: "markerBackground"
            property var textColor: "white"
        }

        MapParameter {
            property var type: "filter"
            property var layer: "markerArrow"
            property var filter: [ "==", "$type", "Point" ]
        }

        MapParameter {
            property var type: "filter"
            property var layer: "markerBackground"
            property var filter: [ "==", "$type", "Point" ]
        }

        states: State {
            name: "moved"; when: mouseArea.pressed
            PropertyChanges { target: linePaint; lineColor: "red"; }
        }

        transitions: Transition {
            ColorAnimation { properties: "lineColor"; easing.type: Easing.InOutQuad; duration: 500 }
        }

        Image {
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 20

            opacity: .75

            sourceSize.width: 80
            sourceSize.height: 80

            source: "icon.png"
        }
    }

    ColorDialog {
        id: landColorDialog
        title: "Land color"
        color: "#e0ded8"
    }

    ColorDialog {
        id: waterColorDialog
        title: "Water color"
        color: "#63c5ee"
    }

    Rectangle {
        anchors.fill: menu
        anchors.margins: -20
        radius: 30
        clip: true
    }

    ColumnLayout {
        id: menu

        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 30

        Label {
            text: "Bearing:"
        }

        Slider {
            id: bearingSlider

            anchors.left: parent.left
            anchors.right: parent.right
            maximumValue: 180
        }

        Label {
            text: "Tilt:"
        }

        Slider {
            id: tiltSlider

            anchors.left: parent.left
            anchors.right: parent.right
            maximumValue: 60
        }

        GroupBox {
            anchors.left: parent.left
            anchors.right: parent.right
            title: "Style:"

            ColumnLayout {
                ExclusiveGroup { id: styleGroup }
                RadioButton {
                    text: map.supportedMapTypes[0].description
                    checked: true
                    exclusiveGroup: styleGroup
                    onClicked: {
                        map.activeMapType = map.supportedMapTypes[0]
                        landColorDialog.color = "#e0ded8"
                        waterColorDialog.color = "#63c5ee"
                    }
                }
                RadioButton {
                    text: map.supportedMapTypes[7].description
                    exclusiveGroup: styleGroup
                    onClicked: {
                        map.activeMapType = map.supportedMapTypes[7]
                        landColorDialog.color = "#343332"
                        waterColorDialog.color = "#191a1a"
                    }
                }
                RadioButton {
                    text: map.supportedMapTypes[4].description
                    exclusiveGroup: styleGroup
                    onClicked: {
                        map.activeMapType = map.supportedMapTypes[4]
                    }
                }
            }
        }

        Button {
            anchors.left: parent.left
            anchors.right: parent.right
            text: "Select land color"
            onClicked: landColorDialog.open()
        }

        Button {
            anchors.left: parent.left
            anchors.right: parent.right
            text: "Select water color"
            onClicked: waterColorDialog.open()
        }

        GroupBox {
            anchors.left: parent.left
            anchors.right: parent.right
            title: "Route:"

            ColumnLayout {
                ExclusiveGroup { id: sourceGroup }
                RadioButton {
                    text: "Route 1"
                    checked: true
                    exclusiveGroup: sourceGroup
                    onClicked: {
                        map.clearMapItems();
                        source.data = ":source1.geojson"
                    }
                }
                RadioButton {
                    text: "Route 2"
                    exclusiveGroup: sourceGroup
                    onClicked: {
                        map.clearMapItems();
                        source.data = ":source2.geojson"
                    }
                }
                RadioButton {
                    text: "Route 3"
                    exclusiveGroup: sourceGroup
                    onClicked: {
                        map.clearMapItems();
                        source.data = '{ "type": "FeatureCollection", "features": \
                            [{ "type": "Feature", "properties": {}, "geometry": { \
                            "type": "LineString", "coordinates": [[ 24.934938848018646, \
                            60.16830257086771 ], [ 24.943315386772156, 60.16227776476442 ]]}}]}'
                    }
                }
                RadioButton {
                    text: "Route 4"
                    exclusiveGroup: sourceGroup
                    onClicked: {
                        map.clearMapItems();

                        var circle = Qt.createQmlObject('import QtLocation 5.3; MapCircle {}', map)
                        circle.center = QtPositioning.coordinate(60.170448, 24.942046) // Helsinki
                        circle.radius = 2000.0
                        circle.border.width = 3

                        map.addMapItem(circle)
                    }
                }
            }
        }

        CheckBox {
            id: toggleRoute
            anchors.left: parent.left
            anchors.right: parent.right
            text: "Toggle route"
            checked: true
        }
    }
}
