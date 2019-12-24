<#macro headSection title link>
  <div class="row head-section">
    <div class="col col-4">
      <h3><a href="${link}">${title}</a></h3>
    </div>
    <div class="col col-6">
      <p>
        <#nested>
      </p>
    </div>
  </div>
</#macro>
