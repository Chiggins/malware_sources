function drawChart(input_data, pie_display, table_display, title) {
	var data = new google.visualization.DataTable();
	data.addColumn('string', 'Version');
	data.addColumn('number', 'Count');
	data.addRows(input_data);

	var options = {
		title: title
		};

	var chart = new google.visualization.PieChart(pie_display);
	chart.draw(data, options);

	var table = new google.visualization.Table(table_display);
	table.draw(data, {/*showRowNumber: true*/});
	}

// Selection
$('#botVersions-td .period a').click(function(){
	var $this = $(this);
	var id = parseInt($this.data('id'));

	var $display = $('#botVersions-Display');
	$display.children().empty();

	drawChart(window.botVersions[id], $display.find('.pie')[0], $display.find('.table')[0], 'Versions');
	return false;
});

// Clicker
$(function(){
	$('a#botVersions').click(function(){
		$('#botVersions-td').show();

		var $display = $('#botVersions-Display');
		$display.children().text('Loading...');

		window.google.load("visualization", "1.0", {
			packages:['corechart', 'table'],
			callback: function(){
				$('#botVersions-td .period a:eq(0)').click();
			}
			});
		return false;
		});
	});


// Botnet activity
$(function(){
	$('#tr-botnet_activity').click(function(){
		var $ba = $('#botnet_activity').show('slow');
		var $tabs = $ba.find('ul.tabs li a');
		$tabs.click(function(){
			var $a = $(this);
			$tabs.removeClass('this');
			$a.addClass('this');
			$ba.find('.display').load($a.attr('href'));
			return false;
		}).filter(':eq(0)').click();
		return false;
	});
});