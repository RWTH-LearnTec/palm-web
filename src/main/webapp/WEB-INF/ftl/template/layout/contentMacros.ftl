<!-- Left side column. contains the logo and sidebar -->
<#macro leftSidebar>
	<aside class="main-sidebar">
		<#nested />
	</aside>
</#macro>

<!-- Content Wrapper. Contains page content -->
<#macro contentWrapper>
    <div class="content-wrapper">
		<#nested />
	</div>
</#macro>