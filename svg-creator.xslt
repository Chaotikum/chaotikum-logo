<?xml version="1.0"?>
<xsl:stylesheet version="1.0" 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/2000/svg"
                xmlns:str="http://exslt.org/strings"
                extension-element-prefixes="str"
                >
  <xsl:output
      method="xml"
      indent="yes"
      standalone="no"
      cdata-section-elements="script"
      media-type="image/svg" />

  <xsl:template name="pins">
    <xsl:param name="pin-ids" />
    <xsl:variable name="total-pin-count" select="count(str:tokenize($pin-ids, ' '))" />
    <xsl:variable name="pin-width" select="//chiprompt/@pin-width" />
    <xsl:variable name="pin-height" select="/chiprompt/@pin-height" />
    <xsl:variable name="pin-padding" select="/chiprompt/@pin-padding" />
    <xsl:variable name="pin-dist"
                  select="(/chiprompt/@width - 2 * /chiprompt/@pin-padding - $pin-width)
                          div ($total-pin-count - 1)" />
    <xsl:for-each select="str:tokenize($pin-ids, ' ')">
      <xsl:variable name="pin-number" select="." />
      <xsl:variable name="rel-pin-number" select="position() - 1" />
      <xsl:variable name="position-shift"
                    select="$pin-height + $pin-padding + $rel-pin-number * $pin-dist" />
      <rect class="{concat('pin', $pin-number)}"
            x="{$position-shift}"
            height="{$pin-height}"
            width="{$pin-width}" />
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="pin-ids">
    <xsl:param name="pin-count" />
    <xsl:param name="start-index" select="0" />
    <xsl:param name="reverse" />
    <xsl:if test="not($reverse) and ($pin-count &gt; 0)">
      <xsl:call-template name="pin-ids">
        <xsl:with-param name="pin-count" select="$pin-count - 1" />
        <xsl:with-param name="start-index" select="$start-index" />
        <xsl:with-param name="reverse" select="$reverse" />
      </xsl:call-template>
    </xsl:if>
    <xsl:value-of select="concat(substring(string(100 + ($pin-count + $start-index)), 2), ' ')" />
    <xsl:if test="($reverse) and $pin-count &gt; 0">
      <xsl:call-template name="pin-ids">
        <xsl:with-param name="pin-count" select="$pin-count - 1" />
        <xsl:with-param name="start-index" select="$start-index" />
        <xsl:with-param name="reverse" select="$reverse" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template match="/">
    <xsl:variable name="pin-padding" select="/chiprompt/@pin-padding"/>
    <xsl:variable name="chip-width" select="/chiprompt/@width"/>
    <xsl:variable name="total-logo-width" select="/chiprompt/@width + 2 * /chiprompt/@pin-height" />
    <xsl:variable name="total-view-width" select="600" />
    <xsl:variable name="total-view-height" select="300" />
    <xsl:variable name="view-shift-x" select="-($total-view-width - $total-logo-width) div 2" />
    <xsl:variable name="view-shift-y" select="-($total-view-height - $total-logo-width) div 2" />

    <svg xmlns="http://www.w3.org/2000/svg"
         xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
         xsl:version="1.0"
         version="1.1"
         baseProfile="full"
         viewBox="{$view-shift-x} {$view-shift-y} {$total-view-width} {$total-view-height}">

      <style>
        .chip {stroke: none;}
        .pin {fill: #666;}
        .active { stroke: #e67206 }
        circle {fill: #666; }
        circle.active {fill:#e67206}
        .pin .active { fill: #e67206; stroke:none }
        .tracers { fill: none; stroke: #666 }
        .chip .chip-body { fill: #1a1a1a }
        .chip .underscore { fill:#b3b3b3; }
        .chip .letter { fill:#ffffff; }
        .chip .prompt-start { fill:#b3b3b3 }
      </style>
      <g class="chip">
        <g class="pin">
          <!-- Pins right -->
          <g class="vertical right"
             transform="translate({$chip-width + 2 * /chiprompt/@pin-height} 0) rotate(90)">
            <xsl:call-template name="pins">
              <xsl:with-param name="pin-ids">
                <xsl:call-template name="pin-ids">
                  <xsl:with-param name="pin-count" select="/chiprompt/pins/vertical-pins/@count - 1" />
                  <xsl:with-param name="reverse">true</xsl:with-param>
                </xsl:call-template>
              </xsl:with-param>
            </xsl:call-template>
          </g>
          <!-- Pins top -->
          <g class="vertical top">
            <xsl:call-template name="pins">
              <xsl:with-param name="pin-ids">
                <xsl:call-template name="pin-ids">
                  <xsl:with-param name="pin-count" select="/chiprompt/pins/horizontal-pins/@count - 1" />
                  <xsl:with-param name="start-index"
                                  select="//vertical-pins/@count" />
                  <xsl:with-param name="reverse">true</xsl:with-param>
                </xsl:call-template>
              </xsl:with-param>
            </xsl:call-template>
          </g>
          <!-- Pins left -->
          <g class="vertical left"
             transform="translate({/chiprompt/@pin-height} 0) rotate(90)">
            <xsl:call-template name="pins">
              <xsl:with-param name="pin-ids">
                <xsl:call-template name="pin-ids">
                  <xsl:with-param name="pin-count" select="/chiprompt/pins/vertical-pins/@count - 1" />
                  <xsl:with-param name="start-index"
                                  select="//horizontal-pins/@count + //vertical-pins/@count" />
                </xsl:call-template>
              </xsl:with-param>
            </xsl:call-template>
          </g>
          <!-- Pins bottom -->
          <g class="vertical bottom"
             transform="translate(0 {$chip-width + /chiprompt/@pin-height})">
            <xsl:call-template name="pins">
              <xsl:with-param name="pin-ids">
                <xsl:call-template name="pin-ids">
                  <xsl:with-param name="pin-count" select="/chiprompt/pins/horizontal-pins/@count - 1" />
                  <xsl:with-param name="start-index"
                                  select="//horizontal-pins/@count + 2 * //vertical-pins/@count" />
                </xsl:call-template>
              </xsl:with-param>
            </xsl:call-template>
          </g>
        </g>
        <!-- Chip -->
        <xsl:variable name="longest-edge-length"
                      select="/chiprompt/@width - 2 * /chiprompt/@pin-padding"/>
        <path class="chip-body"
              d="m {/chiprompt/@pin-height + $pin-padding},{/chiprompt/@pin-height}
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

      <g transform="translate({$view-shift-x}  {$view-shift-y})">
        <xsl:variable name="pin-dist"
                      select="(/chiprompt/@width - 2 * //@pin-padding - //@pin-width) div (5 - 1)" />

        <xsl:variable name="x-line-0" select="$total-view-width div 8" />
        <xsl:variable name="x-line-1" select="($total-view-width div 8) * 3" />
        <xsl:variable name="x-line-2" select="($total-view-width div 8) * 5" />
        <xsl:variable name="x-line-3" select="($total-view-width div 8) * 7" />
        <xsl:variable name="x-line-15" select="($total-view-width div 8) * 4" />

        <xsl:variable name="y-line-0" select="1 * (-$view-shift-y div 4)" />
        <xsl:variable name="y-line-1" select="2 * (-$view-shift-y div 4)" />
        <xsl:variable name="y-line-2" select="3 * (-$view-shift-y div 4)" />
        <xsl:variable name="y-line-3" select="$total-view-height + $view-shift-y + $y-line-0" />
        <xsl:variable name="y-line-4" select="$total-view-height + $view-shift-y + $y-line-1" />
        <xsl:variable name="y-line-5" select="$total-view-height + $view-shift-y + $y-line-2" />

        <xsl:variable name="x-pin-left" select="-$view-shift-x" />
        <xsl:variable name="x-pin-right" select="$total-logo-width - $view-shift-x" />
        <xsl:variable name="y-pin-top" select="-$view-shift-y" />
        <xsl:variable name="y-pin-bottom" select="$total-logo-width - $view-shift-y" />

        <xsl:variable name="x-pin-v0" select="-$view-shift-x + $pin-padding + //@pin-height + (//@pin-width div 2) + 4 * $pin-dist" />
        <xsl:variable name="x-pin-v1" select="-$view-shift-x + $pin-padding + //@pin-height + (//@pin-width div 2) + 3 * $pin-dist" />
        <xsl:variable name="x-pin-v2" select="-$view-shift-x + $pin-padding + //@pin-height + (//@pin-width div 2) + 2 * $pin-dist" />
        <xsl:variable name="x-pin-v3" select="-$view-shift-x + $pin-padding + //@pin-height + (//@pin-width div 2) + 1 * $pin-dist" />
        <xsl:variable name="x-pin-v4" select="-$view-shift-x + $pin-padding + //@pin-height + (//@pin-width div 2) + 0 * $pin-dist" />

        <xsl:variable name="y-pin-v0" select="-$view-shift-y + $pin-padding + //@pin-height + (//@pin-width div 2) + 4 * $pin-dist" />
        <xsl:variable name="y-pin-v1" select="-$view-shift-y + $pin-padding + //@pin-height + (//@pin-width div 2) + 3 * $pin-dist" />
        <xsl:variable name="y-pin-v2" select="-$view-shift-y + $pin-padding + //@pin-height + (//@pin-width div 2) + 2 * $pin-dist" />
        <xsl:variable name="y-pin-v3" select="-$view-shift-y + $pin-padding + //@pin-height + (//@pin-width div 2) + 1 * $pin-dist" />
        <xsl:variable name="y-pin-v4" select="-$view-shift-y + $pin-padding + //@pin-height + (//@pin-width div 2) + 0 * $pin-dist" />

        <xsl:variable name="x-line-dist" select="$total-view-width div 4" />
        <xsl:variable name="y-line-dist" select="$y-line-0" />
        <xsl:variable name="x-pin-to-line" select="$x-line-0 - ($total-logo-width div 2)" />
        <xsl:variable name="y-pin-to-line" select="-$view-shift-y - $y-line-2" />

        <path d="m 0,0 h {$total-view-width} v {$total-view-height} h -{$total-view-width} v -{$total-view-height}"
              fill="none"
              opacity="1"
              stroke="black" />
        <circle class="pin12" cx="{$x-line-0}" cy="0" r="3" />
        <circle class="pin08" cx="{$x-line-1}" cy="0" r="3" />
        <circle class="pin06" cx="{$x-line-2}" cy="0" r="3" />
        <circle class="pin05" cx="{$x-line-3}" cy="0" r="3" />

        <circle class="pin10 pin13" cx="{$x-line-0}" cy="{$total-view-height}" r="3" />
        <circle class="pin11" cx="{$x-line-1}" cy="{$total-view-height}" r="3" />
        <circle class="pin00 pin18" cx="{$x-line-2}" cy="{$total-view-height}" r="3" />
        <circle class="pin03 pin17" cx="{$x-line-3}" cy="{$total-view-height}" r="3" />
        <g class="tracers">
          <path class="pin00 pin18"
                d="m {$x-pin-right},{$y-pin-v0} h {$x-pin-to-line} v {$total-view-height - $y-pin-v0}"
                />
          <path class="pin03 pin17 cat3"
                d="m {$x-pin-right},{$y-pin-v3} h {$x-pin-to-line + $x-line-dist} v {$total-view-height - $y-pin-v3}"
                />

          <path class="pin05"
                d="m {$x-pin-v0},{$y-pin-top} v {-$y-pin-to-line} h {$x-line-3 - $x-pin-v0} v {-$y-line-2}"
                />
          <path class="pin06"
                d="m {$x-pin-v1},{$y-pin-top} v {-$y-pin-to-line - $y-line-dist} h {$x-line-2 - $x-pin-v1} v {-$y-line-1}"
                />
          <path class="pin08"
                d="m {$x-pin-v3},{$y-pin-top} v {-$y-pin-to-line - $y-line-dist} h {$x-line-1 - $x-pin-v3} v {-$y-line-1}"
                />

          <path class="pin10 pin13"
                d="m {$x-pin-left},{$y-pin-v4} h -{$x-line-dist + $x-pin-to-line} v {$total-view-height - $y-pin-v4}"
                />
          <path class="pin11 cat0"
                d="m {$x-pin-left},{$y-pin-v3} h -{$x-pin-to-line} v {$total-view-height - $y-pin-v3}" />
          <path class="pin12 menu0"
                d="m {$x-pin-left},{$y-pin-v2} h {-$x-pin-to-line - ($x-line-dist div 2)} v {- $y-pin-v2 + $y-line-2}
                   h {-$x-line-dist div 2} v {-$y-line-2}" />
          <path class="pin13 pin10 cat1"
                d="m {$x-pin-left},{$y-pin-v1} h -{$x-line-dist + $x-pin-to-line}" />
          <path class="pin10 pin13 cat0"
                d="m {$x-line-0},{$y-pin-v1} v {$total-view-height - $y-pin-v1}" />

          <path class="pin17 pin03 cat3"
                d="m {$x-pin-v2},{$y-pin-bottom} v {$y-pin-to-line + $y-line-dist} h {$x-line-3 - $x-pin-v2}"
                />
          <path class="pin18 pin00 cat2"
                d="m {$x-pin-v1},{$y-pin-bottom} v {$y-pin-to-line} h {$x-line-2 - $x-pin-v1}"
                />
          <path class="pin00 pin18 cat2"
                d="m {$x-line-2},{$y-line-3} v {$total-view-height - $y-line-3}"
                />
        </g>
      </g>
      <script type="text/javascript">
        <![CDATA[
        function update() {
          var currentTime = new Date();
          var secs = currentTime.getSeconds();
          var activatedPins = getPins(secs % 20);
          var deactivatedPins = getPins((secs + 19) % 20);
          for (i = 0; i < deactivatedPins.length; i++) {
            deactivatedPins[i].classList.remove('active');
          }
          for (var i = 0; i < activatedPins.length; i++) {
            activatedPins[i].classList.add('active');
          }
        }
        function getPins(x) {
          var activeNum = x < 10 ? ('0'+x) : x;
          return document.querySelectorAll('.pin'+ activeNum);
        }
        setInterval(update, 100);
        ]]>
      </script>
    </svg>
  </xsl:template>
</xsl:stylesheet>
