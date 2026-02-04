// Based on Qt example with following license:
// Copyright (C) 2024 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtGraphs

Window {
    id: mainView
    width: 1280
    height: 720
    visible: true

    RowLayout  {
        id: graphsRow

        readonly property real margin:  mainView.width * 0.02

        anchors.fill: parent
        anchors.margins: margin
        spacing: margin

        Rectangle {
            Layout.fillHeight: true
            Layout.fillWidth: true
            color: "#262626"
            border.color: "#4d4d4d"
            border.width: 1
            radius: graphsRow.margin

            //! [linegraph]
            GraphsView {
                anchors.fill: parent
                anchors.margins: 16
                theme: GraphsTheme {
                    readonly property color c1: "#DBEB00"
                    readonly property color c2: "#373F26"
                    readonly property color c3: Qt.lighter(c2, 1.5)
                    colorScheme: GraphsTheme.ColorScheme.Dark
                    seriesColors: ["#2CDE85", "#DBEB00"]
                    grid.mainColor: c3
                    grid.subColor: c2
                    axisX.mainColor: c3
                    axisY.mainColor: c3
                    axisX.subColor: c2
                    axisY.subColor: c2
                    axisX.labelTextColor: c1
                    axisY.labelTextColor: c1
                }
                axisX: ValueAxis {
                    min: xmin
                    max: xmax
                    tickInterval: (max-min) / 10
                    subTickCount: 9
                    labelDecimals: 1
                }
                axisY: ValueAxis {
                    min: ymin - 0.1
                    max: ymax + 0.1
                    tickInterval: (max-min) / 10
                    subTickCount: 4
                    labelDecimals: 1
                }
                //! [linegraph]

                //! [linemarker]
                component Marker : Rectangle {
                    width: 16
                    height: 16
                    color: "#ffffff"
                    radius: width * 0.5
                    border.width: 4
                    border.color: "#000000"
                }
                //! [linemarker]

                LineSeries {
                    id: lineSeries1
                    width: 4
                    pointDelegate: Marker { }
                    Component.onCompleted: {
                        replace(xcoords.map((x, i) => Qt.point(x, ycoords[i])))
                    }
                }
            }
        }
    }
}