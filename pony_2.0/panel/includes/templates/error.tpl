<h4 class="achtung_header">
{if $err_code == 'ERR_NOT_ENOUGH_PRIVILEGES'}
	Произошла ошибка: не хватает привилегий!
{elseif $err_code == 'ERR_UNK_LOG_ID'}
	Произошла ошибка: неверный идентификатор лога!
{elseif $err_code == 'ERR_UNK_REPORT_ID'}
	Произошла ошибка: неверный идентификатор отчета!
{elseif $err_code == 'ERR_SRV_CONFIGURATION'}
	Внимание! Проблема с конфигурацией сервера!
{elseif $err_code == 'ERR_WRONG_PASSWORD'}
	Произошла ошибка: неверный пароль!
{elseif $err_code == 'ERR_PASSWORD_MISMATCH'}
	Произошла ошибка: новый пароль и подтверждение не совпадают!
{elseif $err_code == 'ERR_EMPTY_PASSWORD'}
	Произошла ошибка: пустой пароль!
{else}
	Произошла ошибка!
{/if}
</h4><br />

{if isset($back_link)}
<a href="{$smarty.server.SCRIPT_NAME}{$back_link nofilter}">Вернуться и попробовать снова</a>.
<br /><br />
{/if}