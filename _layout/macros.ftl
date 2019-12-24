<#macro headSection title>
  <div class="row">
  <div class="col col-4">
    <h2>${title}</h2>
  </div>
  <div class="col col-8">
    <p>
      <#nested>
    </p>
  </div>
</#macro>
