import Highway from '@dogstudio/highway';
import Fade from './fade.js';

const H = new Highway.Core({
	transitions: {
		default: Fade
	}
});