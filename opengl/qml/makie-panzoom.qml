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
            }

            // MouseArea for panning
            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton
                z: 1
                onPressed: function(mouse) {
                    panning = true;
                    lastMouseX = mouse.x;
                    lastMouseY = mouse.y;
                }
                onReleased: panning = false
                onPositionChanged: function(mouse) {
                    if (panning) {
                        // Calculate pan delta in axis coordinates
                        var dx = mouse.x - lastMouseX;
                        var dy = mouse.y - lastMouseY;
                        lastMouseX = mouse.x;
                        lastMouseY = mouse.y;

                        // Get current axis limits from Julia
                        var x0 = params.xlims[0], x1 = params.xlims[1];
                        var y0 = params.ylims[0], y1 = params.ylims[1];
                        var xrange = x1 - x0;
                        var yrange = y1 - y0;

                        // Pan: move limits by a fraction of the axis range
                        var fx = dx / width;
                        var fy = dy / height;
                        params.xlims = [x0 - fx * xrange, x1 - fx * xrange];
                        params.ylims = [y0 + fy * yrange, y1 + fy * yrange];
                        Julia.update_axes(params.xlims, params.ylims)
                        viewport.update();
                    }
                }
            }

            // WheelHandler for zooming
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
