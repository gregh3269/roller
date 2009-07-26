<%--
  Licensed to the Apache Software Foundation (ASF) under one or more
   contributor license agreements.  The ASF licenses this file to You
  under the Apache License, Version 2.0 (the "License"); you may not
  use this file except in compliance with the License.
  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.  For additional information regarding
  copyright in this work, please see the NOTICE file in the top level
  directory of this distribution.
--%>
<%@ include file="/WEB-INF/jsps/taglibs-struts2.jsp" %>
<script type="text/javascript" src="<s:url value="/roller-ui/scripts/scriptaculous/prototype.js"/>" ></script>

<script type="text/javascript">
<!--
function previewImage(element, theme) {
    element.src="<s:property value="siteURL" />/roller-ui/authoring/previewtheme?theme="+theme;
}

function fullPreview(selector) {
    selected=selector.selectedIndex;
    window.open('<s:url value="/roller-ui/authoring/preview/%{actionWeblog.handle}"/>?theme='+selector.options[selected].value, '_preview', '');
}

function updateThemeChooser(selected) {
    if(selected.value == 'shared') {
        document.getElementById('sharedChooser').style.backgroundColor="#CCFFCC";
        document.getElementById('sharedChooser').style.border="1px solid #008000";
        document.getElementById('sharedOptioner').show();
        
        document.getElementById('customChooser').style.backgroundColor="#eee";
        document.getElementById('customChooser').style.border="1px solid gray";
        document.getElementById('customOptioner').hide();
    } else {
        document.getElementById('customChooser').style.backgroundColor="#CCFFCC";
        document.getElementById('customChooser').style.border="1px solid #008000";
        document.getElementById('customOptioner').show();
        
        document.getElementById('sharedChooser').style.backgroundColor="#eee";
        document.getElementById('sharedChooser').style.border="1px solid gray";
        document.getElementById('sharedOptioner').hide();
    }
}

function toggleImportThemeDisplay() {
    document.getElementById('themeImport').toggle();
}
-->
</script>

<p class="subtitle">
   <s:text name="themeEditor.subtitle" >
       <s:param value="actionWeblog.handle" />
   </s:text>
</p>

<s:form action="themeEdit!save">
    <s:hidden name="weblog" />
    
    <table width="100%" cellpadding="0" cellspacing="0">
        <tr>
            <td width="50%">
                <div id="sharedChooser" class="chooser">
                    <h2><input id="sharedRadio" type="radio" name="themeType" value="shared" <s:if test="!customTheme">checked="true"</s:if> onclick="updateThemeChooser(this)" />&nbsp;<s:text name="themeEditor.sharedTheme" /></h2>
                    <s:text name="themeEditor.sharedThemeDescription" />
                </div>
            </td>
            <td width="50%">
                <div id="customChooser" class="chooser">
                    <h2><input id="customRadio" type="radio" name="themeType" value="custom" <s:if test="customTheme">checked="true"</s:if> onclick="updateThemeChooser(this)" />&nbsp;<s:text name="themeEditor.customTheme" /></h2>
                    <s:text name="themeEditor.customThemeDescription" />
                </div>
            </td>
        </tr>
    </table>
    
    <div id="sharedOptioner" class="optioner" style="display:none;">
        <p>
            <s:if test="!customTheme">
                <s:text name="themeEditor.yourCurrentTheme" />: <b><s:property value="actionWeblog.theme.name"/></b>
            </s:if>
            <s:else>
                <s:text name="themeEditor.selectTheme" />
            </s:else>
        </p>
        
        <p>
            <s:select id="sharedSelector" name="themeId" list="themes" listKey="id" listValue="name" size="1" onchange="previewImage(document.getElementById('sharedPreviewImg'), this[selectedIndex].value)"/>
        </p>
        <p>
            <img id="sharedPreviewImg" src="" />
            <!-- initialize preview image at page load -->
            <script type="text/javascript">
                <s:if test="customTheme">
                    previewImage(document.getElementById('sharedPreviewImg'), '<s:property value="themes[0].id"/>');
                </s:if>
                <s:else>
                    previewImage(document.getElementById('sharedPreviewImg'), '<s:property value="themeId"/>');
                </s:else>
            </script>
        </p>
        <p>
            &raquo; <a href="#" onclick="fullPreview(document.getElementById('sharedSelector'))"><s:text name="themeEditor.previewLink" /></a><br/>
            <s:text name="themeEditor.previewDescription" />
        </p>
        
        <s:if test="!customTheme && actionWeblog.theme.customStylesheet != null">
            <p>
                <s:url action="stylesheetEdit" id="stylesheetEdit" >
                    <s:param name="weblog" value="%{actionWeblog.handle}" />
                </s:url>
                &raquo; <s:a href="%{stylesheetEdit}"><s:text name="themeEditor.customStylesheetLink" /></s:a><br/>
                <s:text name="themeEditor.customStylesheetDescription" />
            </p>
        </s:if>
        <p><s:submit key="themeEditor.save" /></p>
    </div>
    
    <div id="customOptioner" class="optioner" style="display:none;">
        
        <s:if test="firstCustomization">
            <p>
                <s:hidden name="importTheme" value="true" />
                <span class="warning"><s:text name="themeEditor.importRequired" /></span>
            </p>
        </s:if>
        <s:else>
            <s:if test="customTheme">
                <p>
                    <s:url id="templatesUrl" action="templates">
                        <s:param name="weblog" value="%{actionWeblog.handle}" />
                    </s:url>
                    &raquo; <s:a href="%{templatesUrl}"><s:text name="themeEditor.templatesLink" /></s:a><br/>
                    <s:text name="themeEditor.templatesDescription" />
                </p>
            </s:if>
            
            <p>
                <s:checkbox name="importTheme" onclick="document.getElementById('themeImport').toggle();" /><s:text name="themeEditor.import" />
            </p>
        </s:else>
        
        <div id="themeImport" style="display:none;">
            <s:if test="customTheme">
                <p>
                    <span class="warning"><s:text name="themeEditor.importWarning" /></span>
                </p>
            </s:if>
            
            <p>
                <s:select id="customSelector" name="importThemeId" list="themes" listKey="id" listValue="name" size="1" onchange="previewImage(document.getElementById('customPreviewImg'), this[selectedIndex].value)"/>
            </p>
            <p>
                <img id="customPreviewImg" src="" />
                <!-- initialize preview image at page load -->
                <script type="text/javascript">
                <s:if test="customTheme">
                    previewImage(document.getElementById('customPreviewImg'), '<s:property value="themes[0].id"/>');
                </s:if>
                <s:else>
                    previewImage(document.getElementById('customPreviewImg'), '<s:property value="themeId"/>');
                </s:else>
                </script>
            </p>
            <p>
                &raquo; <a href="#" onclick="fullPreview(document.getElementById('customSelector'))"><s:text name="themeEditor.previewLink" /></a><br/>
                <s:text name="themeEditor.previewDescription" />
            </p>
        </div>
        
        <p><s:submit key="themeEditor.save" /></p>
    </div>
    
</s:form>

<%-- initializes the chooser/optioner/themeImport display at page load time --%>
<script type="text/javascript">
    <s:if test="customTheme">
        updateThemeChooser(document.getElementById('customRadio'));
    </s:if>
    <s:else>
        updateThemeChooser(document.getElementById('sharedRadio'));
    </s:else>
    
    <s:if test="firstCustomization">
        document.getElementById('themeImport').show();
    </s:if>
</script>
