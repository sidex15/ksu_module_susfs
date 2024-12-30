import { exec, toast } from 'kernelsu';
import Highway from '@dogstudio/highway';
import { gsap } from 'gsap';
import Fade from './fade.js';
import './space.js';

//module location
const tmpfolder="/debug_ramdisk/susfs4ksu"
const moddir="/data/adb/modules/susfs4ksu"
const config="/data/adb/susfs4ksu"
//susfs_version
var susfs_version = await run(`su -c "grep version= ${moddir}/module.prop | cut -d '=' -f 2"`);
const susfs_version_tag = document.getElementById("susfs_version");
susfs_version_tag.innerHTML=susfs_version

//susfs stats and kernel version
var is_log_empty=await run (`[ -s ${moddir}/susfslogs.txt ] && echo false || echo true`);
var susfs_stats = catToObject(await run(`su -c "cat ${tmpfolder}/susfs_stats.txt"`));
if (is_log_empty=="true" || (susfs_stats.sus_path==0 && susfs_stats.sus_mount==0 && susfs_stats.try_umount==0)){
	susfs_stats = catToObject(await run(`su -c "cat ${tmpfolder}/susfs_stats1.txt"`));
	toast("susfs_stats.txt is empty/missing. Showed Stats from module script");
}

function catToObject(cat){
	// Convert the string content to an object
	const obj = cat
	.split('\n')                    // Split into lines
	.filter(line => line.includes('='))  // Filter valid lines
	.reduce((acc, line) => {
		const [key, value] = line.split('=').map(str => str.trim());
		acc[key] = Number(value); // Map values
		return acc;
	}, {});

	return obj
}

document.getElementById("sus_path").innerHTML= susfs_stats.sus_path;
document.getElementById("sus_mount").innerHTML= susfs_stats.sus_mount;
document.getElementById("try_umount").innerHTML= susfs_stats.try_umount;
document.getElementById("kernel_version").innerHTML= await run(`uname -a | cut -d' ' -f3-`);

//toggles
var is_sus_su_exists = await run(`su -c "[[ -f "${moddir}/sus_su_enabled" || -f "${moddir}/sus_su_mode" ]] && echo true || echo false"`);
const sus_su_152 = document.getElementById("sus_su_152");
const sus_su_142 = document.getElementById("sus_su_142");
const sus_su_NOS = document.getElementById("sus_su_NOS");
//toast(`is_sus_su_exists: ${is_sus_su_exists}`);
if (is_sus_su_exists=="false"){
	sus_su.removeAttribute("checked");
	sus_su.setAttribute("disabled","");
	enable_sus_su.removeAttribute("checked");
	enable_sus_su.setAttribute("disabled","");
	sus_su_NOS.classList.remove("hidden")
}
else{
	if(susfs_version.includes("1.5.2")){
		sus_su_152.classList.remove("hidden")
		sus_su_radio()
	}
	else if(susfs_version.includes("1.4.2")){
		sus_su_142.classList.remove("hidden")
		sus_su_toggle();
	}
}

//highway transition
const H = new Highway.Core({
	transitions: {
		default: Fade
	}
});

//execute again after the transition ends
H.on('NAVIGATE_END', ({ to, from, trigger, location }) => {
	var currentPath = window.location.pathname;
    // Add specific script initializations here
    if (currentPath === '/index.html') {
		console.log("in index");
        keyboard_pop();
		set_uname();
		susfs_log_toggle();
		if(susfs_version.includes("1.5.2") && is_sus_su_exists=="true") sus_su_radio()
		else if(susfs_version.includes("1.4.2") && is_sus_su_exists=="true") sus_su_toggle();
    } else if (currentPath === '/custom.html') {
		//console.log("in custom");
		custom_toggles();
		custom_sus_mount();
		custom_try_umount();
		custom_sus_path();
    }
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

//sus_su for 1.5.2
async function sus_su_radio() {
	const sus_su_0 = document.getElementById("sus_su_0");
	const sus_su_1 = document.getElementById("sus_su_1");
	const sus_su_2 = document.getElementById("sus_su_2");
	const enable_sus_su_1 = document.getElementById("enable_sus_su_1");
	const enable_sus_su_2 = document.getElementById("enable_sus_su_2");
	var is_sus_su_mode_1 = await run(`su -c "if grep -q '^enable_sus_su_mode_1$' ${moddir}/post-fs-data.sh; then echo true; else echo false; fi;"`);
	var is_sus_su_mode_2 = await run(`su -c "if grep -q '^sus_su_2$' ${moddir}/service.sh; then echo true; else echo false; fi;"`);
	var is_sus_su_mode = await run(`su -c "cat ${moddir}/sus_su_mode"`);
	//toast(`sus_su on boot: ${is_sus_su_mode_1}`);
	//toast(`sus_su: ${is_sus_su_enable}`);
	if(is_sus_su_mode=='1'){
		sus_su_0.checked=false
		sus_su_1.checked="checked"
		sus_su_2.checked=false
	}
	else if(is_sus_su_mode=='2'){
		sus_su_0.checked=false
		sus_su_1.checked=false
		sus_su_2.checked="checked"
	}
	else if(is_sus_su_mode=='0'){
		sus_su_0.checked="checked"
		sus_su_1.checked=false
		sus_su_2.checked=false
	}

	if(is_sus_su_mode_1=="true"){
		sus_su_1.removeAttribute("disabled");
		enable_sus_su_1.setAttribute("checked","checked");
	}
	else{
		sus_su_1.setAttribute("disabled","");
		enable_sus_su_1.removeAttribute("checked");
	}
	if (is_sus_su_mode_2=="false"){
		enable_sus_su_2.removeAttribute("checked");
	}
	
	enable_sus_su_1.addEventListener("click", async function(){
		if (enable_sus_su_1.hasAttribute("checked")){
			console.log("false")
			enable_sus_su_1.removeAttribute("checked");
			toast("Reboot to take effect");
			run(`su -c "sed -i 's/^enable_sus_su_mode_1$/#enable_sus_su_mode_1/' ${moddir}/service.sh"`);
		}
		else{
			console.log("true")
			enable_sus_su_1.setAttribute("checked","checked");
			toast("Reboot to take effect");
			run(`su -c "sed -i 's/^#enable_sus_su_mode_1$/enable_sus_su_mode_1/' ${moddir}/service.sh"`);
		}
	});
	enable_sus_su_2.addEventListener("click", async function(){
		if (enable_sus_su_2.hasAttribute("checked")){
			console.log("false")
			enable_sus_su_2.removeAttribute("checked");
			toast("Reboot to take effect");
			run(`su -c "sed -i 's/^sus_su_2$/#sus_su_2/' ${moddir}/service.sh"`);
		}
		else{
			console.log("true")
			enable_sus_su_2.setAttribute("checked","checked");
			toast("Reboot to take effect");
			run(`su -c "sed -i 's/^#sus_su_2$/sus_su_2/' ${moddir}/service.sh"`);	
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
async function set_uname() {
	document.getElementById("kernel_version").innerHTML= await run(`uname -a | cut -d' ' -f3-`);
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

async function custom_toggles() {
	const hide_custom_rom = document.getElementById("hide_custom_rom");
	const more_custom_rom = document.getElementById("more_custom_rom");
	const hide_gapps = document.getElementById("hide_gapps");
	const hide_revanced = document.getElementById("hide_revanced");
	const spoof_cmdline = document.getElementById("spoof_cmdline");
	const hide_ksu_loop = document.getElementById("hide_ksu_loop");
	const force_hide_lsposed = document.getElementById("force_hide_lsposed");
	const hide_vendor_sepolicy = document.getElementById("hide_vendor_sepolicy");
	const hide_compat_matrix = document.getElementById("hide_compat_matrix");
	var config_sh = await run(`su -c "cat ${config}/config.sh"`);

	// Convert the string content to an object
	const custom_settings = config_sh
	.split('\n')                    // Split into lines
	.filter(line => line.includes('='))  // Filter valid lines
	.reduce((acc, line) => {
		const [key, value] = line.split('=').map(str => str.trim());
		acc[key] = value === '1' ? true : value === '0' ? false : value; // Map values
		return acc;
	}, {});

	if (custom_settings.hide_cusrom==true){
		hide_custom_rom.checked="checked";
		more_custom_rom.classList.remove("hidden");
	}
	else{
		hide_custom_rom.checked=false
		more_custom_rom.classList.add("hidden");
	}
	if (custom_settings.hide_vendor_sepolicy==true) hide_vendor_sepolicy.checked="checked";
	else hide_vendor_sepolicy.checked=false;
	if (custom_settings.hide_compat_matrix==true) hide_compat_matrix.checked="checked";
	else hide_compat_matrix.checked=false;
	if (custom_settings.hide_gapps==true) hide_gapps.checked="checked";
	else hide_gapps.checked=false;
	if (custom_settings.hide_revanced==true) hide_revanced.checked="checked";
	else hide_revanced.checked=false;
	if (custom_settings.spoof_cmdline==true) spoof_cmdline.checked="checked";
	else spoof_cmdline.checked=false;
	if (custom_settings.hide_loops==true) hide_ksu_loop.checked="checked";
	else hide_ksu_loop.checked=false;
	if (custom_settings.force_hide_lsposed==true) force_hide_lsposed.checked="checked";
	else force_hide_lsposed.checked=false;

	hide_custom_rom.addEventListener("click",async function (){
		//var vendor_sepolicy_toggle = await run(`su -c "grep -q 'hide_cusrom=1' ${config}/config.sh && echo true || echo false"`);
		const more_custom_rom = document.getElementById("more_custom_rom");
		if (custom_settings.hide_cusrom==true){
			run(`su -c "sed -i 's/hide_cusrom=1/hide_cusrom=0/' ${config}/config.sh"`)
			custom_settings.hide_cusrom=false
			more_custom_rom.classList.add("hidden");
			toast("Reboot to take effect");
		}
		else {
			if (await run(`su -c "grep -q 'hide_cusrom' ${config}/config.sh && echo true || echo false"`)=="false") run(`su -c "echo 'hide_cusrom=1' >> ${config}/config.sh"`)
			else run (`su -c "sed -i 's/hide_cusrom=0/hide_cusrom=1/' ${config}/config.sh"`)
			custom_settings.hide_cusrom=true
			more_custom_rom.classList.remove("hidden");
			toast("Reboot to take effect");
		}
	});

	hide_vendor_sepolicy.addEventListener("click",async function (){
		//var vendor_sepolicy_toggle = await run(`su -c "grep -q 'hide_vendor_sepolicy=1' ${config}/config.sh && echo true || echo false"`);
		if (custom_settings.hide_vendor_sepolicy==true){
			run(`su -c "sed -i 's/hide_vendor_sepolicy=1/hide_vendor_sepolicy=0/' ${config}/config.sh"`)
			custom_settings.hide_vendor_sepolicy=false
			toast("Reboot to take effect");
		}
		else {
			if (await run(`su -c "grep -q 'hide_vendor_sepolicy' ${config}/config.sh && echo true || echo false"`)=="false") run(`su -c "echo 'hide_vendor_sepolicy=1' >> ${config}/config.sh"`)
			else run (`su -c "sed -i 's/hide_vendor_sepolicy=0/hide_vendor_sepolicy=1/' ${config}/config.sh"`)
			custom_settings.hide_vendor_sepolicy=true
			toast("Reboot to take effect");
		}
	});

	hide_compat_matrix.addEventListener("click",async function (){
		//var compat_matrix_toggle = await run(`su -c "grep -q 'hide_compat_matrix=1' ${config}/config.sh && echo true || echo false"`);
		if (custom_settings.hide_compat_matrix==true){
			run(`su -c "sed -i 's/hide_compat_matrix=1/hide_compat_matrix=0/' ${config}/config.sh"`)
			custom_settings.hide_compat_matrix=false
			toast("Reboot to take effect");
		}
		else {
			if (await run(`su -c "grep -q 'hide_compat_matrix' ${config}/config.sh && echo true || echo false"`)=="false") run(`su -c "echo 'hide_compat_matrix=1' >> ${config}/config.sh"`)
			else run (`su -c "sed -i 's/hide_compat_matrix=0/hide_compat_matrix=1/' ${config}/config.sh"`)
			custom_settings.hide_compat_matrix=true
			toast("Reboot to take effect");
		}
	});

	hide_gapps.addEventListener("click",async function (){
		//var gapps_toggle = await run(`su -c "grep -q 'hide_gapps=1' ${config}/config.sh && echo true || echo false"`);
		if (custom_settings.hide_gapps==true){
			await run(`su -c "sed -i 's/hide_gapps=1/hide_gapps=0/' ${config}/config.sh"`)
			custom_settings.hide_gapps=false
			toast("Reboot to take effect");
		}
		else {
			if (await run(`su -c "grep -q 'hide_gapps' ${config}/config.sh && echo true || echo false"`)=="false") run(`su -c "echo 'hide_gapps=1' >> ${config}/config.sh"`)
			else await run(`su -c "sed -i 's/hide_gapps=0/hide_gapps=1/' ${config}/config.sh"`)
			custom_settings.hide_gapps==true
			toast("Reboot to take effect");
		}
	});

	hide_revanced.addEventListener("click",async function (){
		//var revanced_toggle = await run(`su -c "grep -q 'hide_revanced=1' ${config}/config.sh && echo true || echo false"`);
		if (custom_settings.hide_revanced==true){
			await run(`su -c "sed -i 's/hide_revanced=1/hide_revanced=0/' ${config}/config.sh"`)
			custom_settings.hide_revanced=false
			toast("Reboot to take effect");
		}
		else {
			if (await run(`su -c "grep -q 'hide_revanced' ${config}/config.sh && echo true || echo false"`)=="false") run(`su -c "echo 'hide_revanced=1' >> ${config}/config.sh"`)
			else await run(`su -c "sed -i 's/hide_revanced=0/hide_revanced=1/' ${config}/config.sh"`)
			custom_settings.hide_revanced=true
			toast("Reboot to take effect");
		}
	});

	spoof_cmdline.addEventListener("click",async function (){
		//var cmdline_toggle = await run(`su -c "grep -q 'spoof_cmdline=1' ${config}/config.sh && echo true || echo false"`);
		if (custom_settings.spoof_cmdline==true){
			await run(`su -c "sed -i 's/spoof_cmdline=1/spoof_cmdline=0/' ${config}/config.sh"`)
			custom_settings.spoof_cmdline=false
			toast("Reboot to take effect");
		}
		else {
			if (await run(`su -c "grep -q 'spoof_cmdline' ${config}/config.sh && echo true || echo false"`)=="false") run(`su -c "echo 'spoof_cmdline=1' >> ${config}/config.sh"`)
			else await run(`su -c "sed -i 's/spoof_cmdline=0/spoof_cmdline=1/' ${config}/config.sh"`)
			custom_settings.spoof_cmdline=true
			toast("Reboot to take effect");
		}
	});

	hide_ksu_loop.addEventListener("click",async function (){
		//var loops_toggle = await run(`su -c "grep -q 'hide_loops=1' ${config}/config.sh && echo true || echo false"`);
		if (custom_settings.hide_loops==true){
			await run(`su -c "sed -i 's/hide_loops=1/hide_loops=0/' ${config}/config.sh"`)
			custom_settings.hide_loops=false
			toast("Reboot to take effect");
		}
		else {
			if (await run(`su -c "grep -q 'hide_loops' ${config}/config.sh && echo true || echo false"`)=="false") run(`su -c "echo 'hide_loops=1' >> ${config}/config.sh"`)
			else await run(`su -c "sed -i 's/hide_loops=0/hide_loops=1/' ${config}/config.sh"`)
			custom_settings.hide_loops=true
			toast("Reboot to take effect");
		}
	});

	
	force_hide_lsposed.addEventListener("click",async function (){
		//var lsposed_toggle = await run(`su -c "grep -q 'force_hide_lsposed=1' ${config}/config.sh && echo true || echo false"`);
		if (custom_settings.force_hide_lsposed==true){
			await run(`su -c "sed -i 's/force_hide_lsposed=1/force_hide_lsposed=0/' ${config}/config.sh"`)
			custom_settings.force_hide_lsposed=false
			toast("Reboot to take effect");
		}
		else {
			if (await run(`su -c "grep -q 'force_hide_lsposed' ${config}/config.sh && echo true || echo false"`)=="false") run(`su -c "echo 'force_hide_lsposed=1' >> ${config}/config.sh"`)
			else await run(`su -c "sed -i 's/force_hide_lsposed=0/force_hide_lsposed=1/' ${config}/config.sh"`)
			custom_settings.force_hide_lsposed=true
			toast("Reboot to take effect");
		}
	});
}

async function custom_sus_path(){
	const load_sus_path = document.getElementById("load_sus_path");
	const sus_path_area = document.getElementById("custom_sus_path");
	const save_sus_path = document.getElementById("save_sus_path");

	load_sus_path.addEventListener("click",async ()=>{
		sus_path_area.innerHTML=await run(`su -c "cat ${config}/sus_path.txt"`);
	})

	save_sus_path.addEventListener("click",async ()=>{
		var save_sus_path_val=sus_path_area.value;
		//console.log(save_sus_path_val);
		if (save_sus_path_val=='') {
			toast('please press load first!');
		} 
		else{
			await run(`su -c "echo '${save_sus_path_val}' > ${config}/sus_path.txt"`);
			toast("Custom SUS PATH saved!");
			toast("Reboot to take effect");
		}
	})
}

async function custom_sus_mount(){
	const load_sus_mount = document.getElementById("load_sus_mount");
	const sus_mount_area = document.getElementById("custom_sus_mount");
	const save_sus_mount = document.getElementById("save_sus_mount");
	const mainContainer = document.querySelector('main');

	load_sus_mount.addEventListener("click",async ()=>{
		sus_mount_area.innerHTML=await run(`su -c "cat ${config}/sus_mount.txt"`);
	})

	save_sus_mount.addEventListener("click",async ()=>{
		var save_sus_mount_val=sus_mount_area.value;
		if (save_sus_mount_val=='') {
			toast('please press load first!');
		} 
		else{
			await run(`su -c "echo '${save_sus_mount_val}' > ${config}/sus_mount.txt"`);
			toast("Custom SUS MOUNT saved!");
			toast("Reboot to take effect");
		}
	})
}

async function custom_try_umount(){
	const load_try_umount = document.getElementById("load_try_umount");
	const try_umount_area = document.getElementById("custom_try_umount");
	const save_try_umount = document.getElementById("save_try_umount");
	const mainContainer = document.querySelector('main');

	load_try_umount.addEventListener("click",async ()=>{
		try_umount_area.innerHTML=await run(`su -c "cat ${config}/try_umount.txt"`);
	})

	save_try_umount.addEventListener("click",async ()=>{
		var save_try_umount_val=try_umount_area.value;
		if (save_try_umount_val=='') {
			toast('please press load first!');
		} 
		else{
			await run(`su -c "echo '${save_try_umount_val}' > ${config}/try_umount.txt"`);
			toast("Custom SUS MOUNT saved!");
			toast("Reboot to take effect");
		}
	})

	try_umount_area.addEventListener('focus', () => {
		// Add padding to prevent the keyboard from obscuring content
		mainContainer.style.paddingBottom = '300px'; // Adjust padding value based on need
		try_umount_area.scrollIntoView({ behavior: 'smooth', block: 'center', inline: 'nearest' });
	});
	
	try_umount_area.addEventListener('blur', () => {
		// Remove the padding when the input loses focus
		//mainContainer.scrollTo({ top: 0, behavior: 'smooth' });
		/*setTimeout(() => {
			mainContainer.style.paddingBottom = '0px';
		}, 500);*/
		gsap.to(mainContainer, { 
			duration: 0.5, 
			paddingBottom: '0px', 
			ease: 'power1.out' 
		});
	});
}

//Keyboard
function keyboard_pop(){
const inputBox = document.getElementById('sus_uname');
const mainContainer = document.querySelector('main');

inputBox.addEventListener('focus', () => {
    // Add padding to prevent the keyboard from obscuring content
    mainContainer.style.paddingBottom = '350px'; // Adjust padding value based on need
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