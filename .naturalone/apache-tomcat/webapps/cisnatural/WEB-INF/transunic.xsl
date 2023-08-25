<?xml version="1.0" encoding="utf-8"?> 
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" encoding="UTF-8"/>

<!--  ************  START Global variables  ***************** -->
    <xsl:variable name="topoffset" select="0"/> 
    <xsl:variable name="colmultfactor" />  
    <xsl:variable name="rowmultfactor" />
    <xsl:variable name="rowmultfactordef" />
    <xsl:variable name="def_num_rows" select="24"/>	    
    <xsl:variable name="factor1" select="100"/>
    <xsl:variable name="factor2" select="100"/>
    <xsl:variable name="num_rows"/>
    <xsl:variable name="num_cols"/>
    <xsl:variable name="correct_cols"/>
    <xsl:variable name="correct_cols1"/>
    
    <xsl:param name="convert_from" select="'convertFrom'" />
    <xsl:param name="convert_to" select="'convertTo'" />        
<!--  *************  END Global variables  **************** -->

    <xsl:template match="screen">
        <input type="hidden" name="_internal_hiddenscreenid" value="{@id}"/>
        <input style="TOP:-1000px; POSITION:absolute; border-width:0;" readonly="Readonly" maxlen="1" len="1" tabindex="-1" id="_internal_hiddenfocusset" type="hidden"/>
        <input type="hidden" name="_internal_focusobject" value="{@focus_object}"/>
        <input type="hidden" name="_internal_focusdata" value="{@focus_data}"/>
        <input type="hidden" name="_internal_title" value="{@title}"/>
        <input type="hidden" name="_internal_convert_from" value="{$convert_from}"/>
		<input type="hidden" name="_internal_convert_to" value="{$convert_to}"/>

        <xsl:if test="/screen/window/@level &gt; 0">
            <div class="wintitle" >
                <span>
                    <xsl:value-of select="/screen/window/@title" />
                </span>
            </div>
        </xsl:if>
        
        
        <xsl:variable name="num_rows">    
            <xsl:choose>
                <xsl:when test="/screen/window/@level &gt; 0">
                    <xsl:value-of select="/screen/window/@height + 1" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@rows" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
  
        <xsl:variable name="num_cols">    
            <xsl:choose>
                <xsl:when test="/screen/window/@level &gt; 0">
                    <xsl:value-of select="/screen/window/@width + 2" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@cols" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
      	
        <xsl:variable name="colmultfactor">
            <xsl:value-of select="$num_cols"/>
        </xsl:variable>    

        <xsl:variable name="rowmultfactor">
            <xsl:value-of select="$factor2 div $num_rows"/>
        </xsl:variable>
        
        <xsl:variable name="rowmultfactordef">
            <xsl:value-of select="$factor2 div $def_num_rows"/>
        </xsl:variable>	        
 
        <xsl:apply-templates select="window"/>
  
        <xsl:apply-templates select="object">
            <xsl:with-param name="col_mult_factor" select="$colmultfactor" />
            <xsl:with-param name="row_mult_factor" select="$rowmultfactor" />
        </xsl:apply-templates>
  
  
        <xsl:apply-templates select="messageline">
            <xsl:with-param name="col_mult_factor" select="$colmultfactor" />
            <xsl:with-param name="row_mult_factor" select="$rowmultfactor" />
            <xsl:with-param name="row_mult_factor_def" select="$rowmultfactordef" />            
        </xsl:apply-templates>  	
        <xsl:apply-templates select="pfkeys"/>   
    </xsl:template>

    <xsl:template match="object">
        <xsl:param name="col_mult_factor" />
        <xsl:param name="row_mult_factor" />     
        <xsl:variable name="correct_cols">    
            <xsl:choose>
                <xsl:when test="/screen/window/@level &gt; 0">
                    <xsl:value-of select="1" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="0" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
	
        <xsl:variable name="convFrom">
	   <xsl:value-of select="$convert_from" />
	</xsl:variable>
        <xsl:variable name="convTo">
	   <xsl:value-of select="$convert_to" />
	</xsl:variable>	

    <!-- Set underline and blinking attributes    --> 
        <xsl:variable name="TextDecoStyle">
            <xsl:choose>
                <xsl:when test="@underline='True'">natTextDecoUnderline</xsl:when>      
                <xsl:when test="@blinking='True'">natTextDecoBlinking</xsl:when>      
                <xsl:otherwise>natTextDecoNormal</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>       
    
    <!-- Set cursive attribute    -->      
        <xsl:variable name="FontStyle">
            <xsl:choose>
                <xsl:when test="@italic='True'">natFontStyleItalic</xsl:when>          
                <xsl:otherwise>natFontStyleNormal</xsl:otherwise>
            </xsl:choose>      
        </xsl:variable>   
    
    <!-- Set intensified attribute - draw text as bold    -->      
        <xsl:variable name="FontWeight">
            <xsl:choose>
                <xsl:when test="@intensified='True'">natFontWeightBold</xsl:when>      
                <xsl:otherwise>natFontWeightNormal</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>     

        <xsl:variable name="FontWeightCol">
            <xsl:choose>
                <xsl:when test="@intensified='True'">Intensified</xsl:when>      
                <xsl:otherwise></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>  		
    
    
        <xsl:variable name="VariableOrLiteral">
            <xsl:choose>
                <xsl:when test="@literal='True'">FieldLiteralBased</xsl:when>   
                <xsl:otherwise>FieldVariableBased</xsl:otherwise>
            </xsl:choose>
        </xsl:variable> 
            
        <xsl:variable name="style">    
            <xsl:choose>
                <xsl:when test="/screen/@rtl='true'">RIGHT:</xsl:when>   
                <xsl:otherwise>LEFT:</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>  
    
	
	    <xsl:choose>
			<xsl:when test="not(@row=preceding-sibling::*/@row)">
				<br></br>
			</xsl:when>
		</xsl:choose>

        <xsl:choose>									
            <xsl:when test="@type='input'">
                <span type="text" id="Element_{@id}" name="Element_{@id}" data-testtoolid="input_{@col}_{@row}" class="InputField natInput{@forecol} {$FontWeightCol} {$FontWeight} {$TextDecoStyle} {$FontStyle}" style="cursor:text;{$style} {((100 * (@col - 1 + $correct_cols)) div $col_mult_factor)}%;  TOP: {@row*$row_mult_factor+$topoffset}%; POSITION: absolute;" >
                    <xsl:if test="not(@password_field='True')">								
				        <xsl:value-of select="@initstr" />
					</xsl:if> 	
                    <xsl:if test="@reverse='True'">
                        <xsl:attribute name="class">InputField<xsl:text> </xsl:text>reverseInput<xsl:value-of select='@forecol'/><xsl:value-of select='$FontWeightCol'/><xsl:text> </xsl:text>
                            <xsl:value-of select='$FontWeight'/>
                            <xsl:text> </xsl:text>  
                            <xsl:value-of select='$TextDecoStyle'/>
                            <xsl:text> </xsl:text>  
                            <xsl:value-of select='$FontStyle'/>
                        </xsl:attribute>
                    </xsl:if>           
                    <xsl:if test="@dir='rtl'">
                        <xsl:attribute name="dir">rtl</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="@dir='ltr'">
                        <xsl:attribute name="dir">ltr</xsl:attribute>
                    </xsl:if>		    
                    <xsl:choose>
                        <xsl:when test="@readonly='readonly'">
                            <xsl:attribute name="readonly">readonly</xsl:attribute>
                            <xsl:attribute name="name">Skip_<xsl:value-of select="@id"/>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="onfocus">handleFocusSwitch(this.name, this);</xsl:attribute>
                            <xsl:attribute name="ondblclick">handleDoubleClick(this.name, this);</xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="@numeric='True'">
                        <xsl:attribute name="numeric">numeric</xsl:attribute>
                    </xsl:if>
                </span>
            </xsl:when>
      
            <xsl:when test="@type='static'">
                <span id="Element_{@id}" type="text" name="Element_{@id}" data-testtoolid="output_{@col}_{@row}" class="OutputField natOutput{@forecol}{$FontWeightCol} {$VariableOrLiteral} {$FontWeight} {$TextDecoStyle} {$FontStyle}" tabindex="-1" readonly="readonly" style="cursor:text;{$style} {((100 * (@col - 1 + $correct_cols)) div $col_mult_factor)}%;  TOP: {@row*$row_mult_factor+$topoffset}%; POSITION: absolute;" >
                    <xsl:if test="not(@password_field='True')">								
				        <xsl:value-of select="." />
					</xsl:if> 												
                    <xsl:if test="@reverse='True'">
                        <xsl:attribute name="class">OutputField<xsl:text> </xsl:text>reverseOutput<xsl:value-of select='@forecol'/><xsl:value-of select='$FontWeightCol'/><xsl:text> </xsl:text>
                            <xsl:value-of select='$VariableOrLiteral'/>
                            <xsl:text> </xsl:text>       			
                            <xsl:value-of select='$FontWeight'/>
                            <xsl:text> </xsl:text>
                            <xsl:value-of select='$TextDecoStyle'/>
                            <xsl:text> </xsl:text>
                            <xsl:value-of select='$FontStyle'/>     
                        </xsl:attribute>           			       			   
                    </xsl:if>         
                    <xsl:if test="@dir='rtl'">
                        <xsl:attribute name="dir">rtl</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="@dir='ltr'">
                        <xsl:attribute name="dir">ltr</xsl:attribute>
                    </xsl:if>		    
                    <xsl:if test="not(@readonly)">
                        <xsl:attribute name="name">Element_<xsl:value-of select="@id"/>
                        </xsl:attribute>
                        <xsl:attribute name="onclick">
                            handleFocusSwitch(this.id, this)
                        </xsl:attribute>
                        <xsl:attribute name="ondblclick">
                            handleDoubleClick(this.id, null)
                        </xsl:attribute>            
                    </xsl:if>
                </span>
            </xsl:when>			
      <!--xsl:otherwise/-->
        </xsl:choose>
		<xsl:text>  </xsl:text>
    </xsl:template>

    <xsl:template match="messageline">
        <xsl:param name="col_mult_factor" />
        <xsl:param name="row_mult_factor" />
        <xsl:param name="row_mult_factor_def" />           

        <xsl:variable name="correct_cols1">    
            <xsl:choose>
                <xsl:when test="/screen/window/@level &gt; 0">
                    <xsl:value-of select="1" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="0" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
		
        <xsl:variable name="msgstyle">    
            <xsl:choose>
                <xsl:when test="/screen/@rtl='true'">RIGHT:</xsl:when>   
                <xsl:otherwise>LEFT:</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>  
		
        <xsl:variable name="msglevel">    
            <xsl:choose>
                <xsl:when test="/screen/window/@level &gt; 0">
                    <xsl:value-of select="/screen/window/@level" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="0" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>  		
        
        <span id="MessageLine_{$msglevel}" name="MessageLine" class="MessageLine" style="{$msgstyle} {((100 * $correct_cols1) div $col_mult_factor)}%; TOP: {@row*$row_mult_factor+$topoffset}%; POSITION: absolute;" data-screen-left="{$msgstyle} {0}%" data-screen-top="{@row*$row_mult_factor_def+$topoffset}%" data-screen-position="absolute">
            <xsl:value-of select="."/>
        </span>
                
    </xsl:template>

    <xsl:template match="pfkeys">
        <input type="hidden" name="_internal_hiddenpkkeyid" value="{@id}"/>
        <xml id="pfkeydata">
            <pfkeys count="{@count}">
                <xsl:apply-templates select="pfkey"/>
            </pfkeys>
        </xml>
    </xsl:template>

    <xsl:template match="pfkey">
        <pfkey number="{@number}" tooltip="{@tooltip}">
            <xsl:value-of select='.'/>
        </pfkey>
    </xsl:template>

    <xsl:template match="window">
        <xml id="window">
            <nuwindow level="{@level}">
                <nuwintitle>
                    <xsl:value-of select='@title'/>
                </nuwintitle>
                <nuwinwidth>
                    <xsl:value-of select='@width +1'/>
                </nuwinwidth>
                <nuwinheight>
                    <xsl:value-of select='@height'/>
                </nuwinheight>
                <nuwinrow>
                    <xsl:value-of select='@row'/>
                </nuwinrow>
                <nuwincol>
                    <xsl:value-of select='@col'/>
                </nuwincol>
                <nuwinattributes>
                    <xsl:value-of select='@attributes'/>
                </nuwinattributes>
            </nuwindow>
        </xml>
    </xsl:template>

</xsl:stylesheet>
