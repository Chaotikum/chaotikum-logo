<?xml version="1.0"?>
<xsl:stylesheet version="1.0" 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/2000/svg">
  <xsl:output
      method="xml"
      indent="yes"
      standalone="no"
      doctype-public="-//W3C//DTD SVG 1.1//EN"
      doctype-system="http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd"
      media-type="image/svg" />
 
  <xsl:template match="/">
    <xsl:variable name="ph" select="/chiprompt/@pin-height"/>
    <xsl:variable name="pw" select="/chiprompt/@pin-width"/>
    <xsl:variable name="pin-padding" select="/chiprompt/@pin-padding"/>
    <xsl:variable name="chip-width" select="/chiprompt/@width"/>
    <xsl:variable name="total-view-width" select="/chiprompt/@width + 2 * /chiprompt/@pin-height" />
    <xsl:variable name="vpin-dist"
                  select="(/chiprompt/@width - 2 * /chiprompt/@pin-padding - /chiprompt/@pin-width)
                          div (//pins/vertical-pins/@count - 1)" />
    <xsl:variable name="hpin-dist"
                  select="(/chiprompt/@width - 2 * /chiprompt/@pin-padding - /chiprompt/@pin-width)
                          div (//pins/horizontal-pins/@count - 1)"/>

    <svg xmlns="http://www.w3.org/2000/svg"
         xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
         xsl:version="1.0"
         version="1.1"
         viewBox="0 0 {$total-view-width} {$total-view-width}">

      <style>
        .chip {stroke: none;}
        .pin {fill: #666;}
        .chip .chip-body { fill: #1a1a1a }
        .chip .underscore { fill:#b3b3b3; }
        .chip .letter { fill:#ffffff; }
        .chip .prompt-start { fill:#b3b3b3 }
      </style>
      <g class="chip">
        <g class="pin">
          <!-- Pins right -->
          <g class="vertical right" transform="translate({$chip-width + $ph} 0)">
            <rect class="pin00" y="{$ph + $pin-padding + 4 * $vpin-dist}" height="{$pw}" width="{$ph}" />
            <rect class="pin01" y="{$ph + $pin-padding + 3 * $vpin-dist}" height="{$pw}" width="{$ph}" />
            <rect class="pin02" y="{$ph + $pin-padding + 2 * $vpin-dist}" height="{$pw}" width="{$ph}" />
            <rect class="pin03" y="{$ph + $pin-padding + 1 * $vpin-dist}" height="{$pw}" width="{$ph}" />
            <rect class="pin04" y="{$ph + $pin-padding + 0 * $vpin-dist}" height="{$pw}" width="{$ph}" />
          </g>
          <!-- Pins top -->
          <g class="vertical top">
            <rect class="pin05" x="{$ph + $pin-padding + 4 * $hpin-dist}" width="{$pw}" height="{$ph}" />
            <rect class="pin06" x="{$ph + $pin-padding + 3 * $hpin-dist}" width="{$pw}" height="{$ph}" />
            <rect class="pin07" x="{$ph + $pin-padding + 2 * $hpin-dist}" width="{$pw}" height="{$ph}" />
            <rect class="pin08" x="{$ph + $pin-padding + 1 * $hpin-dist}" width="{$pw}" height="{$ph}" />
            <rect class="pin09" x="{$ph + $pin-padding + 0 * $hpin-dist}" width="{$pw}" height="{$ph}" />
          </g>
          <!-- Pins left -->
          <g class="vertical left">
            <rect class="pin10" y="{$ph + $pin-padding + 4 * $vpin-dist}" height="{$pw}" width="{$ph}" />
            <rect class="pin11" y="{$ph + $pin-padding + 3 * $vpin-dist}" height="{$pw}" width="{$ph}" />
            <rect class="pin12" y="{$ph + $pin-padding + 2 * $vpin-dist}" height="{$pw}" width="{$ph}" />
            <rect class="pin13" y="{$ph + $pin-padding + 1 * $vpin-dist}" height="{$pw}" width="{$ph}" />
            <rect class="pin14" y="{$ph + $pin-padding + 0 * $vpin-dist}" height="{$pw}" width="{$ph}" />
          </g>
          <!-- Pins bottom -->
          <g class="vertical bottom" transform="translate(0 {$chip-width + $ph})">
            <rect class="pin15" x="{$ph + $pin-padding + 4 * $hpin-dist}" width="{$pw}" height="{$ph}" />
            <rect class="pin16" x="{$ph + $pin-padding + 3 * $hpin-dist}" width="{$pw}" height="{$ph}" />
            <rect class="pin17" x="{$ph + $pin-padding + 2 * $hpin-dist}" width="{$pw}" height="{$ph}" />
            <rect class="pin18" x="{$ph + $pin-padding + 1 * $hpin-dist}" width="{$pw}" height="{$ph}" />
            <rect class="pin19" x="{$ph + $pin-padding + 0 * $hpin-dist}" width="{$pw}" height="{$ph}" />
          </g>
        </g>
        <!-- Chip -->
        <xsl:variable name="longest-edge-length"
                      select="/chiprompt/@width - 2 * /chiprompt/@pin-padding"/>
        <path class="chip-body"
              d="m {$ph + $pin-padding},{$ph}
                 l {-$pin-padding},{$pin-padding}
                 v {$longest-edge-length}
                 l {$pin-padding},{$pin-padding}
                 h {$longest-edge-length}
                 l {$pin-padding},{-$pin-padding}
                 v {-$longest-edge-length}
                 l {-$pin-padding},{-$pin-padding}
                 h {-$longest-edge-length}
                 z"
                  />
        <!-- Translate values are an hack -->
        <g transform="scale({$chip-width div 73.1}) translate({-$pin-padding div 2.25} {-$pin-padding div 2.25})">
          <g class="prompt">
            <rect class="underscore" width="26.5" height="6.6" x="53.22" y="73.24" />
            <path d="m 30.6,30.36 13.832832,13.83284 0,3.17931 -13.832832,13.83283
                     -3.179314,0 0,-3.17931 12.243161,-12.24319 -12.243161,-12.24316
                     0,-3.17932 3.179314,0" class="prompt-start"
                  />
          </g>
          <!-- C -->
          <path class="letter"
                d="m 58.57,51.07 c 0,1.09326
                   0.234246,2.11958 0.702816,3.07893 0.468518,0.95937 1.08205,1.8072
                   1.840652,2.54346 0.780862,0.71395 1.673295,1.28288 2.677325,1.7068
                   1.026292,0.4016 2.086054,0.6024 3.179315,0.60237 0.870092,3e-5
                   1.695609,-0.12267 2.476525,-0.36813 0.780862,-0.26771
                   1.494809,-0.63585 2.141839,-1.10439 0.647004,-0.46852
                   1.215935,-1.02629 1.706793,-1.67332 0.490832,-0.64701
                   0.870119,-1.36095 1.137862,-2.14187 l 5.28771,0 c -0.312372,1.51718
                   -0.870146,2.92276 -1.673322,4.21679 -0.780916,1.27175
                   -1.740291,2.3873 -2.878127,3.34665 -1.137888,0.93708
                   -2.420766,1.67334 -3.848633,2.2088 -1.427919,0.53546
                   -2.945068,0.80318 -4.551448,0.80318 -1.829521,0 -3.558628,-0.34582
                   -5.187322,-1.03745 -1.628694,-0.69163 -3.056613,-1.62869
                   -4.283705,-2.81118 -1.227119,-1.20481 -2.208809,-2.61038
                   -2.945043,-4.21679 -0.713973,-1.60638 -1.070946,-3.32433
                   -1.070946,-5.15385 l 0,-10.57542 c 0,-1.82947 0.356973,-3.54742
                   1.070946,-5.15382 0.736234,-1.60638 1.717924,-3.00081
                   2.945043,-4.18332 1.227092,-1.20475 2.655011,-2.15297
                   4.283705,-2.84466 1.628694,-0.6916 3.357801,-1.03742
                   5.187322,-1.03747 1.60638,5e-5 3.123529,0.26777 4.551448,0.8032
                   1.427867,0.53551 2.710745,1.28293 3.848633,2.24225 1.137836,0.93712
                   2.097211,2.05267 2.878127,3.34667 0.803176,1.29406 1.36095,2.68849
                   1.673322,4.1833 l -5.28771,0 c -0.267743,-0.75853 -0.64703,-1.46134
                   -1.137862,-2.10837 -0.490858,-0.64701 -1.059789,-1.20478
                   -1.706793,-1.67335 -0.64703,-0.46849 -1.360977,-0.83662
                   -2.141839,-1.10439 -0.780916,-0.26769 -1.606433,-0.40155
                   -2.476525,-0.4016 -1.093261,5e-5 -2.153023,0.21203 -3.179315,0.63587
                   -1.00403,0.40163 -1.896463,0.97056 -2.677325,1.70679
                   -0.758602,0.71398 -1.372134,1.55065 -1.840652,2.51 -0.468544,0.9594
                   -0.702816,1.98569 -0.702816,3.0789 l 0,10.57542" />
        </g>
      </g>
      <g transform="translate(-150 -50)">
        <circle cx="50" cy="200" r="3" />
        <circle cx="150" cy="200" r="3" />
        <circle cx="250" cy="200" r="3" />
        <circle cx="350" cy="200" r="3" />
        <path d="m 0,0 h 400 v 200 h -400 v -200"
              fill="none"
              opacity="1"
              stroke="black" />
      </g>
    </svg>
  </xsl:template>
</xsl:stylesheet>
