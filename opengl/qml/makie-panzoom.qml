import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.julialang

ApplicationWindow {
    width: 800
    height: 400
    visible: true

    property real lastMouseX: 0
    property real lastMouseY: 0
    property bool panning: false

    ColumnLayout {
        anchors.fill: parent

        Label {
            text: "Makie Pan/Zoom Demo"
            font.pixelSize: 18
            Layout.alignment: Qt.AlignHCenter
        }

        MakieViewport {
            id: viewport
            Layout.fillWidth: true
            Layout.fillHeight: true
            renderFunction: render_callback
        
            property int axisThickness: 32
            property real zoomFactor: 0.01  // Adjust for zoom sensitivity
        
            // --- X Axis Zoom Area (bottom) ---
            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: viewport.axisThickness
                color: "transparent"
                z: 2
        
                WheelHandler {
                    onWheel: function(wheel) {
                        var zoom = wheel.angleDelta.y > 0 ? 0.9 : 1.1;
                        var x0 = params.xlims[0], x1 = params.xlims[1];
                        var cx = (x0 + x1) / 2;
                        var xrange = (x1 - x0) * zoom / 2;
                        params.xlims = [cx - xrange, cx + xrange];
                        Julia.update_axes(params.xlims, params.ylims)
                        viewport.update();
                        wheel.accepted = true;
                    }
                }
                // Right-drag to zoom x axis
                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.RightButton
                    property real lastX: 0
                    onPressed: function(mouse) { lastX = mouse.x }
                    onPositionChanged: function(mouse) {
                        var dx = mouse.x - lastX;
                        lastX = mouse.x;
                        if (dx !== 0) {
                            var x0 = params.xlims[0], x1 = params.xlims[1];
                            var cx = (x0 + x1) / 2;
                            var xrange = (x1 - x0);
                            // Drag right = zoom out, left = zoom in
                            var zoom = 1 + viewport.zoomFactor * -dx;
                            var newRange = xrange * zoom;
                            params.xlims = [cx - newRange/2, cx + newRange/2];
                            var flag1 = params.xlims[0] < params.xlims[1]
                            var flag2 = params.ylims[0] < params.ylims[1]
                            if (flag1 & flag2) {
                                Julia.update_axes(params.xlims, params.ylims)
                                viewport.update();
                            }
                        }
                    }
                }
            }
        
            // --- Y Axis Zoom Area (left) ---
            Rectangle {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: viewport.axisThickness
                color: "transparent"
                z: 2
        
                WheelHandler {
                    onWheel: function(wheel) {
                        var zoom = wheel.angleDelta.y > 0 ? 0.9 : 1.1;
                        var y0 = params.ylims[0], y1 = params.ylims[1];
                        var cy = (y0 + y1) / 2;
                        var yrange = (y1 - y0) * zoom / 2;
                        params.ylims = [cy - yrange, cy + yrange];
                        Julia.update_axes(params.xlims, params.ylims)
                        viewport.update();
                        wheel.accepted = true;
                    }
                }
                // Right-drag to zoom y axis
                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.RightButton
                    property real lastY: 0
                    onPressed: function(mouse) { lastY = mouse.y }
                    onPositionChanged: function(mouse) {
                        var dy = mouse.y - lastY;
                        lastY = mouse.y;
                        if (dy !== 0) {
                            var y0 = params.ylims[0], y1 = params.ylims[1];
                            var cy = (y0 + y1) / 2;
                            var yrange = (y1 - y0);
                            // Drag down = zoom out, up = zoom in
                            var zoom = 1 + viewport.zoomFactor * dy;
                            var newRange = yrange * zoom;
                            params.ylims = [cy - newRange/2, cy + newRange/2];
                            var flag1 = params.xlims[0] < params.xlims[1]
                            var flag2 = params.ylims[0] < params.ylims[1]
                            if (flag1 & flag2) {
                                Julia.update_axes(params.xlims, params.ylims)
                                viewport.update();
                            }
                        }
                    }
                }
            }
        
            // --- Main Plot Area ---
            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                z: 1
                property real lastMouseX: 0
                property real lastMouseY: 0
                property bool panning: false
                onPressed: function(mouse) {
                    if (mouse.button === Qt.LeftButton) {
                        panning = true;
                        lastMouseX = mouse.x;
                        lastMouseY = mouse.y;
                    } else if (mouse.button === Qt.RightButton) {
                        lastMouseX = mouse.x;
                        lastMouseY = mouse.y;
                    }
                }
                onReleased: function(mouse) {
                    panning = false;
                }
                onPositionChanged: function(mouse) {
                    if (mouse.buttons & Qt.LeftButton && panning) {
                        // Panning 
                        var dx = mouse.x - lastMouseX;
                        var dy = mouse.y - lastMouseY;
                        lastMouseX = mouse.x;
                        lastMouseY = mouse.y;
        
                        var x0 = params.xlims[0], x1 = params.xlims[1];
                        var y0 = params.ylims[0], y1 = params.ylims[1];
                        var xrange = x1 - x0;
                        var yrange = y1 - y0;
        
                        var fx = dx / width;
                        var fy = dy / height;
                        params.xlims = [x0 - fx * xrange, x1 - fx * xrange];
                        params.ylims = [y0 + fy * yrange, y1 + fy * yrange];
                        Julia.update_axes(params.xlims, params.ylims)
                        viewport.update();
                    } else if (mouse.buttons & Qt.RightButton) {
                        // Right-drag zooms both axes
                        var dx = mouse.x - lastMouseX;
                        var dy = mouse.y - lastMouseY;
                        lastMouseX = mouse.x;
                        lastMouseY = mouse.y;
        
                        var x0 = params.xlims[0], x1 = params.xlims[1];
                        var y0 = params.ylims[0], y1 = params.ylims[1];
                        var cx = (x0 + x1) / 2;
                        var cy = (y0 + y1) / 2;
                        var xrange = (x1 - x0);
                        var yrange = (y1 - y0);
        
                        // Horizontal drag zooms x, vertical drag zooms y
                        var zoomX = 1 + viewport.zoomFactor * -dx;
                        var zoomY = 1 + viewport.zoomFactor * dy;
                        var newRangeX = xrange * zoomX;
                        var newRangeY = yrange * zoomY;
                        params.xlims = [cx - newRangeX/2, cx + newRangeX/2];
                        params.ylims = [cy - newRangeY/2, cy + newRangeY/2];
                        var flag1 = params.xlims[0] < params.xlims[1]
                        var flag2 = params.ylims[0] < params.ylims[1]
                        if (flag1 & flag2) {
                            Julia.update_axes(params.xlims, params.ylims)
                            viewport.update();
                        }
                    }
                }
            }
        
            // WheelHandler for zooming both axes in main plot area
            WheelHandler {
                id: wheelHandler
                target: parent
                onWheel: function(wheel) {
                    var zoom = wheel.angleDelta.y > 0 ? 0.9 : 1.1;
                    var x0 = params.xlims[0], x1 = params.xlims[1];
                    var y0 = params.ylims[0], y1 = params.ylims[1];
                    var cx = (x0 + x1) / 2;
                    var cy = (y0 + y1) / 2;
                    var xrange = (x1 - x0) * zoom / 2;
                    var yrange = (y1 - y0) * zoom / 2;
                    params.xlims = [cx - xrange, cx + xrange];
                    params.ylims = [cy - yrange, cy + yrange];
                    Julia.update_axes(params.xlims, params.ylims)
                    viewport.update();
                }
            }
        }
    }
}
