<div class="box-body">

	  <form role="form" id="editWidget" action="<@spring.url '/admin/widget/edit' />" method="post">
	  	<input type="hidden" name="widgetId" value="${targetWidget.id}" />
	    <#-- text input widget title -->
	    <div class="form-group">
	      <label>Title</label>
	      <input type="text" id="widgetTitle" name="widgetTitle" class="form-control" value="${targetWidget.title}" placeholder="Widget Title">
	    </div>
	    
	    <#-- text input widget unique name -->
	    <div class="form-group">
	      <label>Unique Identifier</label>
	      <input type="text" id="widgetUniqueName" name="widgetUniqueName" class="form-control" value="${targetWidget.uniqueName}" placeholder="an_unique_identifier">
	    </div>
	    
	    <#-- select Widget Type -->
	    <div class="form-group marginTop40Px">
	      <label>Type</label>
	      <select id="widgetType" name="widgetType" class="form-control">
	      	<#list widgetTypes as wType>
	        	<option value="${wType}"<#if targetWidget.widgetType == wType> selected</#if>>${wType?capitalize}</option>
	        </#list>
	      </select>
	    </div>
	    
	    <#-- text input Widget Group -->
	    <div class="form-group">
	      <label>Group Type</label>
	      <input type="text" id="widgetGroup" name="widgetGroup" class="form-control" style="width:50%" value="${targetWidget.widgetGroup!''}" placeholder="Widget Group">
	    </div>
	    
	    <#-- select Widget Source -->
	    <div class="form-group marginTop40Px">
	      <label>Source</label>
	      <select id="widgetSource" name="widgetSource" class="form-control">
	      	<#list widgetSources as wSource>
	        	<option value="${wSource}"<#if targetWidget.widgetSource == wSource> selected</#if>>${wSource?capitalize}</option>
	        </#list>
	      </select>
	    </div>
	    
	    <#-- text input Widget SourcePath -->
	    <div class="form-group">
	      <label>Source Path</label>
	      <input type="text" id="widgetSourcePath" name="widgetSourcePath" class="form-control" value="${targetWidget.sourcePath!''}" placeholder="Widget SourcePath">
	    </div>
	    
	    <#-- select Widget Width -->
	    <div class="form-group marginTop40Px">
	      <label>Width</label>
	      <select id="widgetWidth" name="widgetWidth" class="form-control">
	      	<#list widgetWidths as wWidth>
	        	<option value="${wWidth}"<#if targetWidget.widgetWidth == wWidth> selected</#if>>${wWidth?capitalize}</option>
	        </#list>
	      </select>
	    </div>
	    
	    
	    <#-- text input Widget Position -->
	    <div class="form-group">
	      <label>Position</label>
	      <input type="text" id="position" name="position" class="form-control col-md-4" value="${targetWidget.position}">
	    </div>
	    
	    <#-- select Widget Color -->
	    <div class="form-group">
	      <label>Widget Header Color</label>
	      <select id="widgetColor" name="widgetColor" class="form-control">
	      	<#list widgetColors as wColor>
	        	<option value="${wColor}"<#if targetWidget.color == wColor> selected</#if>>${wColor?capitalize}</option>
	        </#list>
	      </select>
	    </div>
	
	    <#-- textarea Widget Information-->
	    <div class="form-group">
	      <label>Information</label>
	      <textarea name="widgetInfo" id="widgetInfo" class="form-control" rows="3" placeholder="widget help / information">${targetWidget.information!''}</textarea>
	    </div>
	
	    <#-- radio widget close option -->
	    <div class="form-group marginTop40Px">
	      <label>Enable widget close option</label>
	      <div class="radio">
	        <label class="col-md-4">
	          <input type="radio" name="widgetClose" id="widgetClose1" value="on"<#if targetWidget.closeEnabled> checked</#if>>
	          Yes
	        </label>
	        <label>
	          <input type="radio" name="widgetClose" id="widgetClose2" value="off"<#if !targetWidget.closeEnabled> checked</#if>>
	          No
	        </label>
	      </div>
	    </div>
	    
	    <#-- radio widget minimize option -->
	    <div class="form-group">
	      <label>Enable widget minimize option</label>
	      <div class="radio">
	        <label class="col-md-4">
	          <input type="radio" name="widgetMinimize" id="widgetMinimize1" value="on"<#if targetWidget.minimizeEnabled> checked</#if>>
	          Yes
	        </label>
	        <label>
	          <input type="radio" name="widgetMinimize" id="widgetMinimize2" value="off"<#if !targetWidget.minimizeEnabled> checked</#if>>
	          No
	        </label>
	      </div>
	    </div>
	    
	    <#-- widget moveable option -->
	    <div class="form-group">
	      <label>Enable widget moveable</label>
	      <div class="radio">
	        <label class="col-md-4">
	          <input type="radio" name="widgetMoveable" id="widgetMoveable1" value="on"<#if targetWidget.moveableEnabled> checked</#if>>
	          Yes
	        </label>
	        <label>
	          <input type="radio" name="widgetMoveable" id="widgetMoveable2" value="off"<#if !targetWidget.moveableEnabled> checked</#if>>
	          No
	        </label>
	      </div>
	    </div>
	    <#-- radio widget resize option -->
<#--
	    <div class="form-group">
	      <label>Enable widget resize option</label>
	      <div class="radio">
	        <label class="col-md-4">
	          <input type="radio" name="widgetResize" id="widgetResize1" value="on" checked="">
	          Yes
	        </label>
	        <label>
	          <input type="radio" name="widgetResize" id="widgetResize2" value="off">
	          No
	        </label>
	      </div>
	    </div>
-->   
	    <#-- radio widget color option -->
<#--
	    <div class="form-group">
	      <label>Enable widget color option</label>
	      <div class="radio">
	        <label class="col-md-4">
	          <input type="radio" name="widgetColorEnable" id="widgetColorEnable1" value="on" checked="">
	          Yes
	        </label>
	        <label>
	          <input type="radio" name="widgetColorEnable" id="widgetColorEnable2" value="off">
	          No
	        </label>
	      </div>
	    </div>
-->    
	    <#-- radio widget header visible -->
	    <div class="form-group">
	      <label>Is widget contain header?</label>
	      <div class="radio">
	        <label class="col-md-4">
	          <input type="radio" name="headerVisible" id="headerVisible1" value="on"<#if targetWidget.headerVisible> checked</#if>>
	          Yes
	        </label>
	        <label>
	          <input type="radio" name="headerVisible" id="headerVisible2" value="off"<#if !targetWidget.headerVisible> checked</#if>>
	          No
	        </label>
	      </div>
	    </div>
	    
	    <#-- select Widget Status -->
	    <div class="form-group marginTop40Px">
	      <label>Status</label>
	      <select id="widgetStatus" name="widgetStatus" class="form-control">
	      	<#list widgetStatuss as wStatus>
	        	<option value="${wStatus}"<#if targetWidget.widgetStatus == wStatus> selected</#if>>${wStatus?capitalize}</option>
	        </#list>
	      </select>
	    </div>
	
	  </form>
  
</div><#-- ./box-body -->
<div class="box-footer">
  	<button type="button" id="saveChanges" class="btn btn-primary">Save Changes</button>
</div><#-- /.box-footer -->

<script>
$(function(){
	  
	  <#-- submit via ajax -->
		$( "#saveChanges" ).click( function( e ){
			e.preventDefault();
			<#-- put researcher & publication on circle into hidden input -->
			$.post( $("#editWidget").attr( "action" ), $("#editWidget").serialize(), function( data ){
				<#-- if status ok -->
				if( data.status == "ok" ){
					<#-- reload parent page -->
					parent.location = "<@spring.url '/admin?page=widget-' />" + $( "#widgetType" ).val().toLowerCase();
				}
			});
		});
});
</script>