<#macro widget wId="" wTitle="" wType="" wGroup="" wSource="BLANK" wWidth="SMALL" wParams...>
	<#-- local variables --A
	<#-- widget container class -->
	<#local wClassContainer = "">
	
	<#-- widget box class -->
	<#local wClassBox = "box">
	
	<#-- widget width -->
	<#if wWidth == "LARGE">
		<#local wClassContainer = "col-md-12">
	<#elseif wWidth == "MEDIUM">
		<#local wClassContainer = "col-md-8">
	<#else>
		<#local wClassContainer = "col-md-4">
	</#if>
	
	<#if wGroup="sidebar">
		<#local wClassContainer = wClassContainer + " padding0">
		<#local wClassBox = wClassBox + " border0" >
	</#if>
	
	<#-- The widget -->
	<div id="widget-${wId}" class="${wClassContainer}">
      <div class="${wClassBox}">
        <div class="box-header with-border">
        
          <#-- widget handle moveable button -->
          <#if wParams["wMoveableEnabled"] == "true">
      		<div class="btn btn-box-tool box-move-handle" data-widget="move">
          		<i class="fa fa-ellipsis-v"></i>
          		<i class="fa fa-ellipsis-v"></i>
      		</div>
      	  </#if>
      	  
          <div class="box-title-container">
          	<h3 class="box-title">${wTitle}</h3>
          </div>
          <div class="box-tools pull-right">
          	
          	<#-- widget other option dropdown -->
          	<#if wParams["wResizeEnabled"]== "true" || wParams["wColorEnabled"] == "true">
	          	<div class="btn-group">
	              <button class="btn btn-box-tool dropdown-toggle" data-toggle="dropdown"><i class="fa fa-wrench"></i></button>
	              <ul class="dropdown-menu" role="menu">
	                <li><a href="#">Action</a></li>
	                <li><a href="#">Another action</a></li>
	                <li><a href="#">Something else here</a></li>
	                <li class="divider"></li>
	                <li><a href="#">Separated link</a></li>
	              </ul>
	            </div>
	        </#if>
	         
          	<#-- widget help button -->
          	<#if wParams["wInformation"]?? && wParams["wInformation"] != "">
            	<button class="btn btn-box-tool" data-toggle="tooltip" data-placement="bottom" data-html="true" data-original-title="${wParams["wInformation"]}"><i class="fa fa-question"></i></button>
            </#if>
          	
          	<#-- widget minimize button -->
          	<#if wParams["wMinimizeEnabled"] == "true">
            	<button class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i></button>
            </#if>
            
            <#-- widget close button -->
            <#if wParams["wCloseEnabled"] == "true">
            	<button class="btn btn-box-tool" data-widget="remove"><i class="fa fa-times"></i></button>
        	</#if>
          </div>
        </div><#-- /.box-header -->
        
        <#if wSource == "INCLUDE">
    		<#include wParams["wSourcePath"] />
		<#else>
			<div class="box-body">
	            <#-- ajax content goes here -->
	            <#-- if external source, load from iframe -->
	            <#if wSource == "EXTERNAL">
	            	<iframe class="externalContent" alt="external source" width="1" height="1" scrolling="yes" frameborder="no" marginheight="0" marginwidth="0" border="0" src="${wParams["wSourcePath"]}"></iframe>
	            </#if>
	        </div><#-- ./box-body -->
	        <div class="box-footer">
	          	<#-- ajax footer goes here -->
            </div><#-- /.box-footer -->
			
    	</#if>
      </div><#-- /.box -->
    </div><#-- /.container -->
	
</#macro>