<form action="<@spring.url '/researcher/interest' />" method="post" role="form">

<#-- Info -->
<div class="form-group">
  <label class="info-label">Get interest of a researcher</label> 
  <br/> 
  <label class="info-label">Note:<br/>Get researcher ID from first API (Researcher Search). Use only ID from researcher which is added to PALM (isAdded:true)</label>  
</div>

<#-- Researcher Id -->
<div class="form-group">
  <label>id</label>  
  <input name="id" type="text" class="form-control input-md">
  <span class="help-block">Researcher ID gathered from Researcher Search API</span>  
</div>

<#-- Multiple Radios (inline) -->
<div class="form-group">
	<label>updateResult</label>
	<div class="radio">
		<label class="col-md-4">
			<input type="radio" name="updateResult" value="on">
			Yes
		</label>
		<label>
			<input type="radio" name="updateResult" value="off" checked="">
			No
		</label>
	</div>
</div>

<#-- Button -->
<div class="form-group">
    <button onclick="$.PALM.api.submit( $(this) ); return false;" class="btn btn-primary">Execute</button>
</div>

<br/>

<#-- query -->
<div class="form-group">
	<label>API Query</label>
	<textarea class="form-control queryAPI" rows="2" readonly>
	</textarea>
</div>

<div class="form-group">
	<label>API Results</label>
	<pre class="textarea">
	</pre>
</div>
</form>
