(function($) {
	'use strict';

	var Gears = {};

	Gears.messages = {};

	//Gears.data = {};
	Gears.data = {};
	Gears.number = 1;
	Gears.limit = 1;
	Gears.currency = null;
	Gears.loading = false;
	Gears.hourGear = 750;

	Gears.leftNumbers = 3;

	Gears.elements = {};

	Gears.elements.table = $('#gears');
	Gears.elements.message = $('#loader');
	Gears.elements.currency = $('button.currency');

	Gears.elements.gears = $('#gears-number');

	Gears.elements.table.gearsSize = $('#gears-size');
	Gears.elements.table.gearsUniCost = $('#gears-unit-cost');
	Gears.elements.table.gearsCost = $('#gears-cost');
	Gears.elements.table.creditSize = $('#credit-size');
	Gears.elements.table.creditUniCost = $('#credit-unit-cost');
	Gears.elements.table.creditCost = $('#credit-cost');
	Gears.elements.table.mensalCost = $('#total-month');
	Gears.elements.table.totalApproved = $('#total-approved');


	Gears.initialize = function() {
		Gears.loading = true;

		Gears.limit = Gears.elements.table.attr('data-max-gears-limit');

		$.getJSON(Gears.elements.table.attr('data-source'), function(transport) {
			Gears.data = transport;

			Gears.message.hide();
			Gears.clear();

			Gears.loading = false;

		}).fail(function(transport) {
            //console.log(transport);
        });


		$('#add-gear').click(Gears.add);
		$('#remove-gear').click(Gears.remove);

		Gears.elements.currency.click(function() {
			if (Gears.loading) return;

			var button = $(this);
			if (button.hasClass('disabled')) return;

			Gears.elements.currency.removeClass('disabled');
			button.addClass('disabled');

			Gears.currency = button.attr('data-currency');
			Gears.update();
		});
	};

	Gears.add = function() {
		if (Gears.number >= Gears.limit) return;

		Gears.number++;
		Gears.update();
	};

	Gears.remove = function() {
		if (Gears.number < 2) return;

		Gears.number--;
		Gears.update();
	};

	Gears.clear = function() {
		Gears.currency = Gears.elements.table.attr('data-currency');
		Gears.elements.gears.val(Gears.number);
		Gears.update();
	};

	Gears.message = function(text) {
		Gears.elements.message.text(text).fadeIn();
	};

	Gears.message.hide = function() {
		Gears.elements.message.fadeOut();
	};

	Gears.values = {};

	Gears.values.maxGearsToApproved = 0;

	Gears.values.setMaxCost = function(quantity, cost) {

		if (cost > 4000) {
			--quantity;
		}
	};

	Gears.values.cost = function(quantity) {
		 return parseFloat(quantity * Gears.data[Gears.currency].GEAR_USAGE.value);
	};

	Gears.values.total = function(gears, credit) {
		return parseFloat((gears - credit));
	};

	Gears.values.formatedWithCurrency = function(value, leftNumber) {
		return Gears.currency + ' ' + parseFloat(value).toFixed(leftNumber || Gears.leftNumbers);
	};

	Gears.update = function() {

		var gearHours = Gears.hourGear * Gears.number;
		var creditGearHours = 0 * Gears.number;

		var gearsCost = Gears.values.cost(gearHours);
		var creditCost = Gears.values.cost(creditGearHours);
		var totalCost = Gears.values.total(gearsCost, creditCost);

		Gears.elements.gears.val(Gears.number);

		Gears.elements.table.gearsSize.text(gearHours + ' hours');
		Gears.elements.table.gearsUniCost.text(Gears.values.formatedWithCurrency(Gears.data[Gears.currency].GEAR_USAGE.value));
		Gears.elements.table.gearsCost.text(Gears.values.formatedWithCurrency(gearsCost, 2));

		Gears.elements.table.creditSize.text(0 + ' hours');
		Gears.elements.table.creditUniCost.text(Gears.values.formatedWithCurrency(Gears.data[Gears.currency].GEAR_USAGE.value));
		Gears.elements.table.creditCost.text(Gears.values.formatedWithCurrency(creditCost, 2));
		
		Gears.elements.table.mensalCost.text(Gears.values.formatedWithCurrency(totalCost, 2));
		Gears.elements.table.totalApproved.text(Gears.values.formatedWithCurrency(totalCost * 12, 2));
	};

	// Initialize
	Gears.initialize();

}(jQuery));