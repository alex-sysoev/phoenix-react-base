export function cleanField( props ) {
	let _props = { ...props };
	
	const invalid = [
		'initialValue', 'autofill', 'onUpdate', 'valid', 'invalid', 'dirty', 'pristine',
		'active', 'touched', 'visited', 'autofilled', 'error', 'asyncValidating', "controlType",
		'apiError'
	];

	invalid.forEach(p => {
	 	delete _props[p];
	});

	return _props;
}