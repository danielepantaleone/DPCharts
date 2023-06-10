<p align="center">
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./Assets/DPChartsLogo.png" width="300">
  <img alt="logo" src="./Assets/DPChartsLogo.png" width="300">
</picture>
</p>

<br/>

[![Swift](https://img.shields.io/badge/Swift-5.7,_5.8-orange?style=rounded)](https://img.shields.io/badge/Swift-5.7,_5.8-Orange?style=rounded)
[![Platform](https://img.shields.io/badge/Platform-iOS-Blue?style=rounded)](https://img.shields.io/badge/Platform-iOS-Blue?style=rounded)

DPCharts is a Swift-based lightweight framework designed specifically for rendering charts on iOS. Its main objective is to create a user-friendly chart library that follows the iOS delegation pattern approach. Each chart within the framework is responsible solely for presenting data, rather than managing the data itself. To manage the data, you provide the chart with a data source object (an object conforming to the chart datasource protocol). Additionally, charts manage gesture interaction, and touch gesture events are delivered to the configured delegate (an object conforming to the chart delegate protocol) when applicable.