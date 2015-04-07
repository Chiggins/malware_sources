	{* Navigation menu *}
	<a class="update_nav" href="{$smarty.server.SCRIPT_NAME}?token={$token}&amp;action=stats">Обновить</a><br /><br />
	
	<div class="mychart">
	<img width="680" height="230" src="{$smarty.server.SCRIPT_NAME}?token={$token}&amp;action=chart&amp;routine=last_24_hours" alt="" />
 	</div>	
	<div class="mychart">
	<img width="680" height="230" src="{$smarty.server.SCRIPT_NAME}?token={$token}&amp;action=chart&amp;routine=last_month" alt="" />
 	</div>	
	<div class="mychart" style="height: 250px;">
	<img width="680" height="250" src="{$smarty.server.SCRIPT_NAME}?token={$token}&amp;action=chart&amp;routine=os" alt="" />
 	</div>	

	{* FTP Clients stats *}
 	{if count($ftp_clients_list)}
	<h4>Популярность FTP клиентов</h4>
	<table id="FTPClientsStats" width="700" cellspacing="0" summary="FTP clients popularity">
	<tbody><tr>
	<th width="75%">FTP клиент</th>
	<th width="25%">Количество паролей</th>
	</tr></tbody>
	<tbody>
	{assign var="max_ftp_client_list" value=10}
	{foreach from=$ftp_clients_list item=ftp_client name=ftp_client_traversal}
		{assign var=img_file value="includes/design/images/modules/"|cat:$ftp_client.module|cat:".png"}
		{if file_exists($img_file)}
			{assign var=img_url value="<img style=\"margin-top:-2px;vertical-align:middle;\" src=\""|cat:$img_file|cat:"\" width=\"16\" height=\"16\" alt=\"\" /> "}
		{else}
			{assign var=img_url value=""}
		{/if}

		{if $smarty.foreach.ftp_client_traversal.index == $max_ftp_client_list}
			{assign var=ftp_clients_extra_data value=true}
			</tbody>
			<tbody id="hidden_rows_ftp" style="display: none;">
		{elseif $smarty.foreach.ftp_client_traversal.index < $max_ftp_client_list}
		{/if}
		<tr>
		<td style="padding-bottom:2px">{$img_url nofilter}{$ftp_client.name}</td>
		<td><b>{$ftp_client.count}</b> ({$ftp_client.percentage}%)</td>
		</tr>
	{/foreach}
	</tbody></table>
	{* Show more FTPClients link *}
	{if isset($ftp_clients_extra_data)}
		<div style="width:700px">
		<p align="right"><a class="local_nav_ftp" href="javascript:showMore('_ftp')">Показать все</a> <font style="font-size:11px;">({count($ftp_clients_list)})</font></p>
		</div>
	{/if}
	<br />
	{/if}

	{* HTTP Clients stats *}
	{if $enable_http_mode && ($show_http_to_users || $priv_is_admin)}
	 	{if count($http_clients_list)}
			<h4>Популярность интернет браузеров</h4>
			<table id="HTTPClientsStats" width="700" cellspacing="0" summary="HTTP clients popularity">
			<tbody><tr>
			<th width="75%">Браузер</th>
			<th width="25%">Количество паролей</th>
			</tr></tbody>
			<tbody>
			{assign var="max_http_client_list" value=10}
			{foreach from=$http_clients_list item=http_client name=http_client_traversal}
				{assign var=img_file value="includes/design/images/modules/"|cat:$http_client.module|cat:".png"}
				{if file_exists($img_file)}
					{assign var=img_url value="<img style=\"margin-top:-2px;vertical-align:middle;\" src=\""|cat:$img_file|cat:"\" width=\"16\" height=\"16\" alt=\"\" /> "}
				{else}
					{assign var=img_url value=""}
				{/if}
		
				{if $smarty.foreach.http_client_traversal.index == $max_http_client_list}
					{assign var=http_clients_extra_data value=true}
					</tbody>
					<tbody id="hidden_rows_http" style="display: none;">
				{elseif $smarty.foreach.http_client_traversal.index < $max_http_client_list}
				{/if}
				<tr>
				<td style="padding-bottom:2px">{$img_url nofilter}{$http_client.name}</td>
				<td><b>{$http_client.count}</b> ({$http_client.percentage}%)</td>
				</tr>
			{/foreach}
			</tbody></table>
			{* Show more HTTPClients link *}
			{if isset($http_clients_extra_data)}
				<div style="width:700px">
				<p align="right"><a class="local_nav_http" href="javascript:showMore('_http')">Показать все</a> <font style="font-size:11px;">({count($http_clients_list)})</font></p>
				</div>
			{/if}
			<br />
		{/if}
	{/if}

	{if $enable_email_mode && ($show_email_to_users || $priv_is_admin)}
        {* E-mail Clients stats *}
	 	{if count($email_clients_list)}
			<h4>Популярность E-mail клиентов</h4>
			<table id="EmailClientsStats" width="700" cellspacing="0" summary="E-mail clients popularity">
			<tr>
			<th width="75%">E-mail клиент</th>
			<th width="25%">Количество паролей</th>
			</tr>

			{foreach from=$email_clients_list item=email_client}
				<tr>
				{assign var=img_file value="includes/design/images/modules/"|cat:$email_client.module|cat:".png"}
				{if file_exists($img_file)}
					{assign var=img_url value="<img style=\"margin-top:-2px;vertical-align:middle;\" src=\""|cat:$img_file|cat:"\" width=\"16\" height=\"16\" alt=\"\" /> "}
				{else}
					{assign var=img_url value=""}
				{/if}
	
				<td style="padding-bottom:2px">{$img_url nofilter}{$email_client.name}</td>
				<td><b>{$email_client.count}</b> ({$email_client.percentage}%)</td>
				</tr>
			{/foreach}
			</table>
			<br />
		{/if}
	{/if}

	{* HTTP domain stats *}
	{if $enable_http_mode && ($show_http_to_users || $priv_is_admin)}
	 	{if count($http_domain_list)}
			<h4>Популярность HTTP доменов</h4>
			<table id="HTTPDomainStats" width="700" cellspacing="0" summary="HTTP domains popularity">
			<tbody><tr>
			<th width="75%">Домен</th>
			<th width="25%">Количество паролей</th>
			</tr></tbody>
			<tbody>
			{assign var="max_http_domain_list" value=10}
			{foreach from=$http_domain_list item=http_domain name=http_domain_traversal}
				{assign var=img_url value="<img style=\"margin-top:-2px;vertical-align:middle;\" src=\"includes/design/images/domain_icon.png\" width=\"16\" height=\"16\" alt=\"\" /> "}
		
				{if $smarty.foreach.http_domain_traversal.index == $max_http_domain_list}
					{assign var=http_domain_extra_data value=true}
					</tbody>
					<tbody id="hidden_rows_http_dom" style="display: none;">
				{elseif $smarty.foreach.http_domain_traversal.index < $max_http_domain_list}
				{/if}
				<tr>
				<td style="padding-bottom:2px">{$img_url nofilter}{$http_domain.domain}</td>
				<td><b>{$http_domain.count}</b> ({$http_domain.percentage}%)</td>
				</tr>
			{/foreach}
			</tbody></table>
			{* Show more HTTPdomains link *}
			{if isset($http_domain_extra_data)}
				<div style="width:700px">
				<p align="right"><a class="local_nav_http_dom" href="javascript:showMore('_http_dom')">Показать все</a> <font style="font-size:11px;">({count($http_domain_list)})</font></p>
				</div>
			{/if}
			<br />
		{/if}
	{/if}

	{* Bitcoin clients stats *}
 	{if count($bitcoin_clients_list)}
		<h4>Популярность Bitcoin клиентов</h4>
		<table id="BitcoinClientsStats" width="700" cellspacing="0" summary="Bitcoin clients popularity">
		<tbody><tr>
		<th width="75%">Bitcoin клиент</th>
		<th width="25%">Количество кошельков</th>
		</tr></tbody>
		<tbody>
		{assign var="max_bitcoin_client_list" value=5}
		{foreach from=$bitcoin_clients_list item=bitcoin_client name=bitcoin_client_traversal}
			{assign var=img_file value="includes/design/images/modules/"|cat:$bitcoin_client.module|cat:".png"}
			{if file_exists($img_file)}
				{assign var=img_url value="<img style=\"margin-top:-2px;vertical-align:middle;\" src=\""|cat:$img_file|cat:"\" width=\"16\" height=\"16\" alt=\"\" /> "}
			{else}
				{assign var=img_url value=""}
			{/if}
	
			{if $smarty.foreach.bitcoin_client_traversal.index == $max_bitcoin_client_list}
				{assign var=bitcoin_clients_extra_data value=true}
				</tbody>
				<tbody id="hidden_rows_bitcoin" style="display: none;">
			{elseif $smarty.foreach.bitcoin_client_traversal.index < $max_bitcoin_client_list}
			{/if}
			<tr>
			<td style="padding-bottom:2px">{$img_url nofilter}{$bitcoin_client.name}</td>
			<td><b>{$bitcoin_client.count}</b> ({$bitcoin_client.percentage}%)</td>
			</tr>
		{/foreach}
		</tbody></table>
		{* Show more Bitcoin Clients link *}
		{if isset($bitcoin_clients_extra_data)}
			<div style="width:700px">
			<p align="right"><a class="local_nav_bitcoin" href="javascript:showMore('_bitcoin')">Показать все</a> <font style="font-size:11px;">({count($bitcoin_clients_list)})</font></p>
			</div>
		{/if}
		<br />
	{/if}


	{* Country stats *}
 	{if count($country_list)}
		<h4>Статистика по странам</h4>
		<table id="CountryStats" width="700" cellspacing="0" summary="Country statistics">
		<tbody><tr>
		<th width="50%">Страна</th>
		<th width="25%">Количество отчетов</th>
		<th width="25%">Количество паролей</th>
		</tr></tbody>
		<tbody>
		{assign var="max_country_list" value=10}
		{foreach from=$country_list item=country_item name=country_list_traversal}
			{if $smarty.foreach.country_list_traversal.index == $max_country_list}
				{assign var=country_list_extra_data value=true}
				</tbody>
				<tbody id="hidden_rows_country" style="display: none;">
			{/if}

			<tr>
			{if $country_item.country_code == ''}
			<td><div style="margin-left:20px">Неизвестно</div></td>
			{else}
			<td>{country base_path="includes/design/images/flags/" country_code=$country_item.country_code country_name=$country_item.country_name}</td>
			{/if}
			<td><b>{$country_item.report_count}</b> ({$country_item.report_percentage}%)</td>
			<td><b>{$country_item.ftp_count}</b> ({$country_item.ftp_percentage}%)</td>
			</tr>
		{/foreach}
		</tbody></table>

		{* Show more country link *}
		{if isset($country_list_extra_data)}
			<div style="width:700px">
			<p align="right"><a class="local_nav_country" href="javascript:showMore('_country')">Показать все</a> <font style="font-size:11px;">({count($country_list)})</font></p>
			</div>
		{/if}
	{/if}
