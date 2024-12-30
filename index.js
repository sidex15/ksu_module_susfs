import { exec, toast } from 'kernelsu';
import Highway from '@dogstudio/highway';
import Fade from './fade.js';
import './space.js';

//module location
const moddir="/data/adb/modules/susfs4ksu"


//susfs stats and kernel version
var is_log_empty=await run (`[ -s ${moddir}/susfslogs.txt ] && echo false || echo true`);
if (is_log_empty=="true"){
	var sus_path= await run(`su -c "grep '\${SUSFS_BIN} add_sus_path' ${moddir}/*.sh | wc -l"`);
	var sus_mount= await run(`su -c "grep '\${SUSFS_BIN} add_sus_mount' ${moddir}/*.sh | wc -l"`);
	var try_umount= await run(`su -c "grep '\${SUSFS_BIN} add_try_umount' ${moddir}/*.sh | wc -l"`);
	toast("susfslogs.txt is empty/missing. Showed Stats from module script");
}
else{
	var sus_path= await run(`su -c "grep 'CMD_SUSFS_ADD_SUS_PATH'  ${moddir}/susfslogs.txt | wc -l"`);
	var sus_mount= await run(`su -c "grep 'CMD_SUSFS_ADD_SUS_MOUNT'  ${moddir}/susfslogs.txt | wc -l"`);
	var try_umount= await run(`su -c "grep 'CMD_SUSFS_ADD_TRY_UMOUNT'  ${moddir}/susfslogs.txt | wc -l"`);
	//toast("DEBUG: Showed from susfslogs.txt");
}
document.getElementById("sus_path").innerHTML= sus_path;
document.getElementById("sus_mount").innerHTML= sus_mount;
document.getElementById("try_umount").innerHTML= try_umount;
document.getElementById("kernel_version").innerHTML= await run(`uname -a | cut -d' ' -f3-`);

//toggles
var is_sus_su_exists = await run(`su -c "[ -f ${moddir}/sus_su_enabled ] && echo true || echo false"`);
//toast(`is_sus_su_exists: ${is_sus_su_exists}`);
if (is_sus_su_exists=="false"){
	sus_su.removeAttribute("checked");
	sus_su.setAttribute("disabled","");
	enable_sus_su.removeAttribute("checked");
	enable_sus_su.setAttribute("disabled","");
}
else{
	sus_su_toggle();
}


//highway transition
const H = new Highway.Core({
	transitions: {
		default: Fade
	}
});

//execute again after the transition ends
H.on('NAVIGATE_END', ({ to, from, trigger, location }) => {
	keyboard_pop()
	if(is_sus_su_exists=="true") sus_su_toggle();
	set_uname();
	susfs_log_toggle();
});

//run function
async function run(cmd) {
	const { errno, stdout, stderr } = await exec(cmd);
	if (errno != 0) {
		toast(`stderr: ${stderr}`);
		return undefined;
	} else {
		return stdout;
	}
}

//sus_su toggle
async function sus_su_toggle() {
	const sus_su = document.getElementById("sus_su");
	const enable_sus_su = document.getElementById("enable_sus_su");
	var is_enable_sus_su = await run(`su -c "if grep -q '^enable_sus_su$' ${moddir}/service.sh; then echo true; else echo false; fi;"`);
	var is_sus_su_enable = await run(`su -c "cat ${moddir}/sus_su_enabled"`);
	//toast(`sus_su on boot: ${is_enable_sus_su}`);
	//toast(`sus_su: ${is_sus_su_enable}`);
	if(is_enable_sus_su=='true'){
		sus_su.addEventListener("click",function(){
		if (sus_su.getAttribute("checked")){
			console.log("false")
			run(`su -c ksu_susfs sus_su 0`)
			exec(`su -c echo 0 > ${moddir}/sus_su_enabled`)
			toast("sus su off no need to reboot")
			sus_su.removeAttribute("checked");
		}
		else{
			console.log("true")
			run(`su -c ksu_susfs sus_su 1`)
			exec(`su -c echo 1 > ${moddir}/sus_su_enabled`)
			toast("sus su on no need to reboot")
			sus_su.setAttribute("checked","checked");
		}
	});
	}
	else{
		sus_su.removeAttribute("checked");
		enable_sus_su.removeAttribute("checked");
		sus_su.setAttribute("disabled","");
	}
	if(is_sus_su_enable=="0"){
		sus_su.removeAttribute("checked");
	}
	enable_sus_su.addEventListener("click",async function(){
		if (is_enable_sus_su=='true' && enable_sus_su.getAttribute("checked")){
			console.log("false")
			toast("Reboot to take effect");
			run(`su -c "sed -i 's/^enable_sus_su$/#enable_sus_su/' ${moddir}/service.sh"`);
			enable_sus_su.removeAttribute("checked");
			sus_su.setAttribute("disabled","");
		}
		else{
			console.log("true")
			toast("Reboot to take effect");
			run(`su -c "sed -i 's/^#enable_sus_su$/enable_sus_su/' ${moddir}/service.sh"`);
			enable_sus_su.setAttribute("checked","checked");
			sus_su.removeAttribute("disabled","");
		}
	});
}

//Toast function
/*function showToast(msg){
	const sustoast = document.getElementById('toast');
	sustoast.textContent = msg;

	// Show and animate the toast
	sustoast.classList.remove('opacity-0','hidden');

	// Hide the toast after 3 seconds
	setTimeout(() => {
		sustoast.classList.add('opacity-0');
		
		// Completely hide after animation
		setTimeout(() => {
			sustoast.classList.add('hidden');
		}, 300); // Match the duration of the transition
	}, 3000);
}*/

//set uname function
function set_uname() {
	const set_uname=document.getElementById("set_uname");
	set_uname.addEventListener("click",async function(){
		var sus_uname=document.getElementById("sus_uname").value;
		if (sus_uname.includes(' ')) {
			toast('Spaces are not allowed in the input!');
		} 
		else {
			if(sus_uname==''){
				console.log("default kernel version");
				run(`su -c "ksu_susfs set_uname 'default' 'default'"`)
				document.getElementById("kernel_version").innerHTML= await run(`uname -a | cut -d' ' -f3-`);
				set_uname.blur();
			}
			else{
				console.log(`sets to ${sus_uname}`);
				run(`su -c "ksu_susfs set_uname '${sus_uname}' 'default'"`)
				document.getElementById("kernel_version").innerHTML= await run(`uname -a | cut -d' ' -f3-`);
				set_uname.blur();
			}
		}
	});
}

//susfs log toggle
async function susfs_log_toggle() {
	var susfs_log=document.getElementById("susfs_log");
	var is_susfs_log_enabled=await run(`su -c "grep -q 'enable_log 1' /data/adb/modules/susfs4ksu/service.sh && echo true || echo false"`);
	//toast(`is susfs log enabled: ${is_susfs_log_enabled}`);
	susfs_log.addEventListener("click",async function() {
		if(susfs_log.hasAttribute("checked")){
			console.log("false")
			toast("Reboot to take effect");
			await run(`su -c "sed -i 's/enable_log 1/enable_log 0/' ${moddir}/service.sh"`);
			susfs_log.removeAttribute("checked");
		}
		else{
			console.log("true")
			toast("Reboot to take effect");
			await run(`su -c "sed -i 's/enable_log 0/enable_log 1/' ${moddir}/service.sh"`);
			susfs_log.setAttribute("checked","checked");
		}
	})
	if(is_susfs_log_enabled=="false"){
		susfs_log.removeAttribute("checked");
	}
	else{
		susfs_log.setAttribute("checked","checked");
	}
}

//Keyboard
function keyboard_pop(){const inputBox = document.getElementById('sus_uname');
const mainContainer = document.querySelector('main');

inputBox.addEventListener('focus', () => {
    // Add padding to prevent the keyboard from obscuring content
    mainContainer.style.paddingBottom = '300px'; // Adjust padding value based on need
    inputBox.scrollIntoView({ behavior: 'smooth', block: 'center', inline: 'nearest' });
});

inputBox.addEventListener('blur', () => {
    // Remove the padding when the input loses focus
    mainContainer.scrollTo({ top: 0, behavior: 'smooth' });
	setTimeout(() => {
		mainContainer.style.paddingBottom = '0px';
	}, 500);
	
});
}

//susfsstats();
set_uname()
keyboard_pop();
susfs_log_toggle();