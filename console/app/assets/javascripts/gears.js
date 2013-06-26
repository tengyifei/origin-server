(function($) {
	'use strict';

	/*
	 * Contants
	 */
	var GEAR_HOURS = 750;
	var APROVVED_MONTHS = 12;
	var VALUE_LEFT_NUMBERS = 2;

	/*
	 * Gears Object
	 *
	 */
	var Gears = {};

	/*
	 *
	 */
	Gears._data = null;

	/*
	 * Gears.config
	 *
	 */
	Gears.config = {}

	/*
	 *
	 */
	Gears.config.currency = null;

	/*
	 *
	 */
	Gears.config.consumed_gears = 1;

	/*
	 *
	 */
	Gears.config.credits = 0;

	/*
	 *
	 */
	Gears.config.max_gears = 0;

	/*
	 *
	 */
	Gears.config.start_gears = 0;

	/*
	 *
	 */
	Gears.current_gears = 0;

	/*
	 *
	 */
	Gears.View = {};

	/*
	 *
	 */
	Gears.View.elements = {};

	/*
	 *
	 */
	Gears.View.elements.body = $('body');

	/*
	 *
	 */
	Gears.View.elements.message = $('#message');

	/*
	 *
	 */
	Gears.View.elements.gears = $('#gears-number');

	/*
	 *
	 */
	Gears.View.elements.buttons = {};

	/*
	 *
	 */
	Gears.View.elements.buttons.add = $('#add-gear');

	/*
	 *
	 */
	Gears.View.elements.buttons.remove = $('#remove-gear');

	/*
	 *
	 */
	Gears.View.elements.buttons.currencies = $('button.currency');

	/*
	 *
	 */
	Gears.View.elements.table = $('#gears');

	/*
	 *
	 */
	Gears.View.elements.table.gears = $('#gears-size');

	/*
	 *
	 */
	Gears.View.elements.table.gears_unit_cost = $('#gears-unit-cost');

	/*
	 *
	 */
	Gears.View.elements.table.gears_cost = $('#gears-cost');

	/*
	 *
	 */
	Gears.View.elements.table.credit = $('#credit-size');

	/*
	 *
	 */
	Gears.View.elements.table.credit_unit_cost = $('#credit-unit-cost');

	/*
	 *
	 */
	Gears.View.elements.table.credit_cost = $('#credit-cost');

	/*
	 *
	 */
	Gears.View.elements.table.total_month = $('#total-month');

	/*
	 *
	 */
	Gears.View.elements.table.total_approved = $('#total-approved');	

	/*
	 *
	 */
	Gears.View.message = function(text) {
		Gears.View.elements.message.text(text).fadeIn();
	};

	/*
	 *
	 */
	Gears.View.message.hide = function() {
		Gears.View.elements.message.fadeOut();
	};

	Gears.View.format_to_currency = function(value, left_numbers) {
		return Gears.Billing.config.acronym + ' ' + parseFloat(value).toFixed(left_numbers || VALUE_LEFT_NUMBERS);
	};

	/*
	 *
	 */
	Gears.View.update = function() {

		Gears.View.elements.gears.val(Gears.current_gears);

		Gears.View.elements.table.gears.text(Gears.Billing.gears.value + ' hours');
		Gears.View.elements.table.gears_unit_cost.text(Gears.View.format_to_currency(Gears.Billing.gears.unit_cost, 3));
		Gears.View.elements.table.gears_cost.text(Gears.View.format_to_currency(Gears.Billing.gears.cost));

		Gears.View.elements.table.credit.text(Gears.Billing.credit.value + ' hours');
		Gears.View.elements.table.credit_unit_cost.text(Gears.View.format_to_currency(Gears.Billing.credit.unit_cost, 3));
		Gears.View.elements.table.credit_cost.text(Gears.View.format_to_currency(-Gears.Billing.credit.cost));
		
		Gears.View.elements.table.total_month.text(Gears.View.format_to_currency(Gears.Billing.month.total));
		Gears.View.elements.table.total_approved.text(Gears.View.format_to_currency(Gears.Billing.approved.total));
	};

	/*
	 *
	 */
	Gears.View.loading = false;

	/*
	 *
	 */
	Gears.View._load_attempts = 0;

	/*
	 *
	 */
	Gears.Billing = {
		gears: { value: 0, unit_cost: 0, cost: 0 },
		credit: { value: 0, unit_cost: 0, cost: 0 },
		month: { total: 0 },
		approved: { total: 0 }
	};

	/*
	 *
	 */
	Gears.Billing.config = {};

	/*
	 *
	 */
	Gears.Billing.init = function() {

		Gears.Billing.set_config(Gears.config.currency);
		Gears.Billing.credit();

		Gears.update();
	};

	/*
	 *
	 */
	Gears.Billing.set_config = function(currency) {
		Gears.Billing.config = Gears._data[currency].GEAR_USAGE;
	};

	Gears.Billing.credit = function() {
		Gears.Billing.credit.value = Gears.config.credit;
		Gears.Billing.credit.unit_cost = Gears.Billing.config.value;
		Gears.Billing.credit.cost = Gears.Billing.credit.unit_cost * Gears.Billing.credit.value;
	};

	/*
	 *
	 */
	Gears.Billing.update = function() {

		Gears.Billing.gears.value = Gears.current_gears * GEAR_HOURS;
		Gears.Billing.gears.unit_cost = Gears.Billing.config.value;
		Gears.Billing.gears.cost = Gears.Billing.gears.value * Gears.Billing.gears.unit_cost;

		Gears.Billing.month.total = Math.max(0, Gears.Billing.gears.cost - Gears.Billing.credit.cost);
		Gears.Billing.approved.total = Gears.Billing._get_approved();
	};	

	/*
	 *
	 */
	Gears.Billing._get_approved = function() {
		return Math.min(APROVVED_MONTHS * Gears.Billing.month.total, Gears.Billing.config.limit);
	};

	/*
	 *
	 */
	Gears.init = function() {
		Gears.config.consumed_gears = parseInt(Gears.View.elements.table.gears.attr('data-consumed-gears'), 10) || 1;
		Gears.config.max_gears = parseInt(Gears.View.elements.table.attr('data-max-gears-limit'), 10);
		Gears.config.credit = parseInt(Gears.View.elements.table.credit.attr('data-hours'), 10);
		Gears.config.currency = Gears.View.elements.table.attr('data-currency');

		Gears.current_gears = parseInt(Gears.View.elements.table.gears.attr('data-gears'), 10) || 1;
		Gears.config.start_gears = Gears.current_gears;

		Gears._load_getup_config();
		Gears._bind_events();
	};

	/*
	 *
	 */
	Gears._load_getup_config = function() {
		Gears.View.loading = true;
		Gears.View.message('Loading gears info...');

		var source = Gears.View.elements.table.attr('data-source');

		$.getJSON(source, function(transport) {
			Gears._data = transport;

			Gears.View.message.hide();
			Gears.View.loading = false;

			Gears.Billing.init();
		});//.fail(function(transport) {});
	};

	/*
	 *
	 */
	Gears._bind_events = function() {
		Gears.View.elements.buttons.add.mousedown(function() {
			Gears.add();

			Gears.buttons.start_timer(Gears.add);
		});

		Gears.View.elements.buttons.remove.mousedown(function() {
			Gears.remove();
			
			Gears.buttons.start_timer(Gears.remove);
		});

		Gears.View.elements.body.mouseup(function() {
			Gears.buttons.stop_timer();
		});

		Gears.View.elements.buttons.currencies.click(function() {
			if (Gears.View.loading) return;

			var button = $(this);
			if (button.hasClass('disabled')) return;

			Gears.View.elements.buttons.currencies.removeClass('disabled');
			button.addClass('disabled');			

			Gears.set_currency(button.attr('data-currency'));
		});
	};

	/*
	 *
	 */
	Gears.buttons = {};

	/*
	 *
	 */
	Gears.buttons._timer = null;

	/*
	 *
	 */
	Gears.buttons.speed = 200;

	/*
	 *
	 */
	Gears.buttons.start_timer = function(method) {
		clearTimeout(Gears.buttons._timer);
		Gears.buttons.speed = 200;

		var action = function() {
			Gears.buttons._timer = setTimeout(function() {
				method();
				action();
			}, Gears.buttons.speed);

			Gears.buttons.speed -= 20;
		};

		action();
	};

	/*
	 *
	 */
	Gears.buttons.stop_timer = function() {
		clearTimeout(Gears.buttons._timer);
	};

	/*
	 *
	 */
	Gears.add = function() {
		if (Gears.View.loading) return;
		if (Gears.current_gears >= Gears.config.max_gears) return;

		Gears.current_gears++;
		Gears.update();
	};

	/*
	 *
	 */
	Gears.remove = function() {
		if (Gears.View.loading) return;
		if (Gears.current_gears <= Gears.config.start_gears) return;

		Gears.current_gears--;
		Gears.update();
	};

	/*
	 *
	 */
	Gears.set_currency = function(currency) {
		Gears.Billing.set_config(currency);
		Gears.Billing.credit();

		Gears.update();
	};

	/*
	 *
	 */
	Gears.update = function() {
		Gears.Billing.update();
		Gears.View.update();
	};

	/*
	 *
	 */
	Gears.init();

}(jQuery));