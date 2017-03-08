export const RESET_API_ERRORS = "RESET_API_ERRORS";

export function resetApiErrors() {
	return (dispatch) => {
		dispatch({
			type: RESET_API_ERRORS
		});
	}
}