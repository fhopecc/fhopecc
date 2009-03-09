function calc(cmd) {
  disp = $('calc_display')
  switch (cmd)
	{
		case 'C':
			disp.value = ''
		  break
		case '+/-':
			disp.value = '-' + disp.value
			break
		case '=':
      disp.value = eval(disp.value)
			break
		default:
			disp.value = disp.value + cmd
	}
}
