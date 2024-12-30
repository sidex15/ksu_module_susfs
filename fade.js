import Highway from "@dogstudio/highway";
import Tween from 'gsap';

class Fade extends Highway.Transition{
    in({ from, to, done }){
        from.remove();

        Tween.fromTo(to, 0.5, { opacity: 0 }, { 
            opacity: 1, 
            onComplete: () => {
                done();
            } 
        });
    }

    out({ from, done }){
        Tween.fromTo( from, 0.5, { opacity: 1 }, { 
            opacity: 0, 
            onComplete: () => {
                done();
            }  
        });
    }
}

export default Fade;