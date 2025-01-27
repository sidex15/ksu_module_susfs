import{H as U,F as D,g as F}from"./fade-DXKTELhO.js";(function(){const s=document.createElement("link").relList;if(s&&s.supports&&s.supports("modulepreload"))return;for(const n of document.querySelectorAll('link[rel="modulepreload"]'))i(n);new MutationObserver(n=>{for(const u of n)if(u.type==="childList")for(const _ of u.addedNodes)_.tagName==="LINK"&&_.rel==="modulepreload"&&i(_)}).observe(document,{childList:!0,subtree:!0});function c(n){const u={};return n.integrity&&(u.integrity=n.integrity),n.referrerPolicy&&(u.referrerPolicy=n.referrerPolicy),n.crossOrigin==="use-credentials"?u.credentials="include":n.crossOrigin==="anonymous"?u.credentials="omit":u.credentials="same-origin",u}function i(n){if(n.ep)return;n.ep=!0;const u=c(n);fetch(n.href,u)}})();let j=0;function q(e){return`${e}_callback_${Date.now()}_${j++}`}function y(e,s){return typeof s>"u"&&(s={}),new Promise((c,i)=>{const n=q("exec");window[n]=(_,f,h)=>{c({errno:_,stdout:f,stderr:h}),u(n)};function u(_){delete window[_]}try{ksu.exec(e,JSON.stringify(s),n)}catch(_){i(_),u(n)}})}function o(e){ksu.toast(e)}const V="/assets/blue-8Pd85PrK.png",I="/assets/brown-DkMF-zd4.png",W="/assets/cyan-CxxU9VUc.png",J="/assets/cyan1-BWTE1JdY.png",Y="/assets/orange-Dz5Wr5v6.png",X="/assets/orange1-CeH2ZIyG.png",G="/assets/yellow-Bmr_vY2u.png",K="/assets/green-BwBzMX7_.png",Z="/assets/lime-DPDNUj7v.png",Q="/assets/pink-BsJVk9ad.png",ee="/assets/purple-b3Qaozit.png",te="/assets/red-DsgSinuJ.png",se="/assets/white-BOZMyur9.png",oe="/assets/black-CWwxUpmx.png",l=document.getElementById("backgroundCanvas"),m=l.getContext("2d");function x(){l.width=window.innerWidth,l.height=window.innerHeight,M()}const w=[],B=[],ne=100,R=[V,I,I,W,J,Y,X,G,K,Z,Q,ee,te,se,oe];R.length;function ae(){w.length=0;for(let e=0;e<ne;e++)w.push({x:Math.random()*l.width,y:Math.random()*l.height,radius:Math.random()*2,speed:Math.random()*.5})}function ce(e,s){return[...e].sort(()=>.5-Math.random()).slice(0,s)}function M(){B.length=0,ce(R,6).forEach(s=>{const c=new Image;c.src=s,c.onload=()=>{B.push({img:c,x:Math.random()*l.width,y:Math.random()*l.height,width:50,height:60,rotation:Math.random()*Math.PI*2,rotationSpeed:(Math.random()-.5)*.02,speedX:(Math.random()-.5)*1.5,speedY:(Math.random()-.5)*1.5})}})}function S(){m.clearRect(0,0,l.width,l.height),m.fillStyle="white",w.forEach(e=>{m.beginPath(),m.arc(e.x,e.y,e.radius,0,Math.PI*2),m.fill(),e.y+=e.speed,e.y>l.height&&(e.y=0,e.x=Math.random()*l.width)}),B.forEach(e=>{m.save(),m.translate(e.x+e.width/2,e.y+e.height/2),m.rotate(e.rotation),m.drawImage(e.img,-e.width/2,-e.height/2,e.width,e.height),m.restore(),e.x+=e.speedX,e.y+=e.speedY,e.rotation+=e.rotationSpeed,e.x>l.width&&(e.x=-e.width),e.x+e.width<0&&(e.x=l.width),e.y>l.height&&(e.y=-e.height),e.y+e.height<0&&(e.y=l.height)}),requestAnimationFrame(S)}window.addEventListener("resize",x);x();ae();M();S();const A="/data/adb/ksu/susfs4ksu",T="/data/adb/modules/susfs4ksu",d="/data/adb/susfs4ksu",k="/data/adb/ksu/bin/ksu_susfs",b=E(await t(`cat ${d}/config.sh`));var p=await t(`grep version= ${T}/module.prop | cut -d '=' -f 2`);const de=document.getElementById("susfs_version");de.innerHTML=p;var ie=await t(`[ -s ${T}/susfslogs.txt ] && echo false || echo true`),g=E(await t(`cat ${A}/susfs_stats.txt`));(ie=="true"||g.sus_path==0&&g.sus_mount==0&&g.try_umount==0)&&(g=E(await t(`cat ${A}/susfs_stats1.txt`)),o("susfs_stats.txt is empty/missing. Showed Stats from module script"));function E(e){return e.split(`
`).filter(c=>c.includes("=")).reduce((c,i)=>{const[n,u]=i.split("=").map(_=>_.trim());return c[n]=Number(u),c},{})}document.getElementById("sus_path").innerHTML=g.sus_path;document.getElementById("sus_mount").innerHTML=g.sus_mount;document.getElementById("try_umount").innerHTML=g.try_umount;document.getElementById("kernel_version").innerHTML=await t("uname -a | cut -d' ' -f3-");var L=b.sus_su;document.getElementById("sus_su_152");const ue=document.getElementById("sus_su_154"),$=document.getElementById("sus_su_142"),_e=document.getElementById("sus_su_1"),le=document.getElementById("sus_su_NOS");L==-1?(sus_su.removeAttribute("checked"),sus_su.setAttribute("disabled",""),enable_sus_su.removeAttribute("checked"),enable_sus_su.setAttribute("disabled",""),le.classList.remove("hidden")):p.includes("1.5")?L==1?_e.classList.remove("hidden"):($.classList.remove("hidden"),H(b)):p.includes("1.4.2")&&($.classList.remove("hidden"),C(b));p.includes("1.5.4")&&(ue.classList.remove("hidden"),N());const re=new U.Core({transitions:{default:D}});re.on("NAVIGATE_END",async({to:e,from:s,trigger:c,location:i})=>{const n=E(await t(`cat ${d}/config.sh`));var u=window.location.pathname;u==="/index.html"?(console.log("in index"),P(),O(n),z(n),p.includes("1.5.4")&&N(),p.includes("1.5")?H(n):p.includes("1.4.2")&&C(n)):u==="/custom.html"&&(fe(n),he(),ge(),me())});async function t(e){const{errno:s,stdout:c,stderr:i}=await y(e);if(s!=0){o(`stderr: ${i}`);return}else return c}async function C(e){const s=document.getElementById("sus_su"),c=document.getElementById("enable_sus_su");var i=e.sus_su,n=e.sus_su_active;i==1?s.addEventListener("click",function(){n==1?(console.log("false"),t(`${k} sus_su 0`),y(`sed -i 's/sus_su_active=.*/sus_su_active=0/' ${d}/config.sh`),o("sus su off no need to reboot"),s.removeAttribute("checked")):(console.log("true"),t(`${k} sus_su 1`),y(`sed -i 's/sus_su_active=.*/sus_su_active=1/' ${d}/config.sh`),o("sus su on no need to reboot"),s.setAttribute("checked","checked"))}):(s.checked=!1,c.checked=!1,s.setAttribute("disabled","")),n==0&&(s.checked=!1),c.addEventListener("click",async function(){i==1&&c.checked=="checked"?(console.log("false"),o("Reboot to take effect"),t(`sed -i 's/sus_su=.*/sus_su=0/' ${d}/config.sh`),y(`sed -i 's/sus_su_active=.*/sus_su_active=0/' ${d}/config.sh`),c.checked=!1,s.setAttribute("disabled","")):(console.log("true"),o("Reboot to take effect"),t(`sed -i 's/sus_su=.*/sus_su=1/' ${d}/config.sh`),c.checked="checked",s.removeAttribute("disabled",""))})}async function H(e){const s=document.getElementById("sus_su"),c=document.getElementById("enable_sus_su");var i=e.sus_su,n=e.sus_su_active;i==0&&(c.checked=!1),n==0&&(s.checked=!1),s.addEventListener("click",function(){n==2?(console.log("false"),t(`${k} sus_su 0`),y(`sed -i 's/sus_su_active=.*/sus_su_active=0/' ${d}/config.sh`),o("sus su off no need to reboot")):(console.log("true"),t(`${k} sus_su 1`),y(`sed -i 's/sus_su_active=.*/sus_su_active=2/' ${d}/config.sh`),o("sus su on no need to reboot"))}),c.addEventListener("click",async function(){i==2?(console.log("false"),o("Reboot to take effect"),t(`sed -i 's/sus_su=.*/sus_su=0/' ${d}/config.sh`)):(console.log("true"),o("Reboot to take effect"),t(`sed -i 's/sus_su=.*/sus_su=2/' ${d}/config.sh`))})}async function N(){const e=document.getElementById("auto_mount"),s=document.getElementById("auto_bind"),c=document.getElementById("auto_umount_bind"),i=document.getElementById("try_umount_zygote");var n=await t("[ -f data/adb/susfs_no_auto_add_sus_ksu_default_mount ] && echo true || echo false"),u=await t("[ -f data/adb/susfs_no_auto_add_sus_bind_mount ] && echo true || echo false"),_=await t("[ -f data/adb/susfs_no_auto_add_try_umount_for_bind_mount ] && echo true || echo false"),f=await t("[ -f data/adb/susfs_umount_for_zygote_system_process ] && echo true || echo false");n=="true"&&(e.checked=!1),u=="true"&&(s.checked=!1),_=="true"&&(c.checked=!1),f=="false"&&(i.checked=!1),e.addEventListener("click",async function(){n=="true"?(await t("rm -f data/adb/susfs_no_auto_add_sus_ksu_default_mount"),o("Reboot to take effect")):(await t("touch data/adb/susfs_no_auto_add_sus_ksu_default_mount"),o("Reboot to take effect"))}),s.addEventListener("click",async function(){u=="true"?(await t("rm -f data/adb/susfs_no_auto_add_sus_bind_mount"),o("Reboot to take effect")):(await t("touch data/adb/susfs_no_auto_add_sus_bind_mount"),o("Reboot to take effect"))}),c.addEventListener("click",async function(){_=="true"?(await t("rm -f data/adb/susfs_no_auto_add_try_umount_for_bind_mount"),o("Reboot to take effect")):(await t("touch data/adb/susfs_no_auto_add_try_umount_for_bind_mount"),o("Reboot to take effect"))}),i.addEventListener("click",async function(){f=="true"?(await t("rm -f data/adb/susfs_umount_for_zygote_system_process"),o("Reboot to take effect")):(await t("touch data/adb/susfs_umount_for_zygote_system_process"),o("Reboot to take effect"))})}async function O(e){document.getElementById("kernel_version").innerHTML=await t("uname -a | cut -d' ' -f3-");const s=document.getElementById("set_uname"),c=document.getElementById("uname-spoof-on-boot"),i=document.getElementById("uname-spoof-on-postfsdata"),n=document.getElementById("uname-at-postfs"),u=document.getElementById("confirm_modal"),_=document.getElementById("modal_confirm"),f=document.getElementById("modal_cancel"),h=document.getElementById("modal_message"),r=e;r.spoof_uname>0?(c.checked="checked",n.classList.remove("hidden")):(c.checked=!1,n.classList.add("hidden")),r.spoof_uname>1?i.checked="checked":i.checked=!1,s.addEventListener("click",async function(){var a=document.getElementById("sus_uname");a.value.includes(" ")?o("Spaces are not allowed in the input!"):a.value==""?(console.log("default kernel version"),t(`${k} set_uname 'default' 'default'`),t(`echo default > ${d}/kernelversion.txt`),document.getElementById("kernel_version").innerHTML=await t("uname -a | cut -d' ' -f3-"),s.blur()):(console.log(`sets to ${a.value}`),t(`${k} set_uname '${a.value}' 'default'`),t(`echo ${a.value} > ${d}/kernelversion.txt`),document.getElementById("kernel_version").innerHTML=await t("uname -a | cut -d' ' -f3-"),a.value="",s.blur())}),c.addEventListener("change",async function(a){const v=document.getElementById("uname-at-postfs");a.preventDefault(),r.spoof_uname<1?(await t(`sed -i 's/spoof_uname=.*/spoof_uname=1/' ${d}/config.sh`),r.spoof_uname=1,o("Reboot to take effect"),v.classList.remove("hidden")):(await t(`sed -i 's/spoof_uname=.*/spoof_uname=0/' ${d}/config.sh`),r.spoof_uname=0,i.checked=!1,o("Reboot to take effect"),v.classList.add("hidden"))}),i.addEventListener("change",async function(a){a.preventDefault(),r.spoof_uname<2?(h.textContent="Setting this on may cause a bootloop or instability if spoofed incorrectly. Are you sure you want to enable post-fs-data execution?",u.showModal()):await t(`sed -i 's/spoof_uname=.*/spoof_uname=1/' ${d}/config.sh`)}),_.addEventListener("click",async function(){const a=document.getElementById("uname-spoof-on-postfsdata");a.checked="checked",await t(`sed -i 's/spoof_uname=.*/spoof_uname=2/' ${d}/config.sh`),r.spoof_uname=2,o("Reboot to take effect"),u.close()}),f.addEventListener("click",async function(){const a=document.getElementById("uname-spoof-on-postfsdata");a.checked=!1,u.close()})}async function z(e){var s=document.getElementById("susfs_log");e.susfs_log===1?s.setAttribute("checked","checked"):s.removeAttribute("checked"),s.addEventListener("click",async function(){s.hasAttribute("checked")?(console.log("false"),o("Reboot to take effect"),await t(`sed -i 's/susfs_log=1/susfs_log=0/' ${d}/config.sh`),s.removeAttribute("checked")):(console.log("true"),o("Reboot to take effect"),await t(`sed -i 's/susfs_log=0/susfs_log=1/' ${d}/config.sh`),s.setAttribute("checked","checked"))})}async function fe(e){const s=document.getElementById("hide_custom_rom"),c=document.getElementById("more_custom_rom"),i=document.getElementById("hide_gapps"),n=document.getElementById("hide_revanced"),u=document.getElementById("spoof_cmdline"),_=document.getElementById("hide_ksu_loop"),f=document.getElementById("force_hide_lsposed"),h=document.getElementById("hide_vendor_sepolicy"),r=document.getElementById("hide_compat_matrix"),a=e;a.hide_cusrom==!0?(s.checked="checked",c.classList.remove("hidden")):(s.checked=!1,c.classList.add("hidden")),a.hide_vendor_sepolicy==!0?h.checked="checked":h.checked=!1,a.hide_compat_matrix==!0?r.checked="checked":r.checked=!1,a.hide_gapps==!0?i.checked="checked":i.checked=!1,a.hide_revanced==!0?n.checked="checked":n.checked=!1,a.spoof_cmdline==!0?u.checked="checked":u.checked=!1,a.hide_loops==!0?_.checked="checked":_.checked=!1,a.force_hide_lsposed==!0?f.checked="checked":f.checked=!1,s.addEventListener("click",async function(){const v=document.getElementById("more_custom_rom");a.hide_cusrom==!0?(t(`sed -i 's/hide_cusrom=1/hide_cusrom=0/' ${d}/config.sh`),a.hide_cusrom=!1,v.classList.add("hidden"),o("Reboot to take effect")):(t(`sed -i 's/hide_cusrom=0/hide_cusrom=1/' ${d}/config.sh`),a.hide_cusrom=!0,v.classList.remove("hidden"),o("Reboot to take effect"))}),h.addEventListener("click",async function(){a.hide_vendor_sepolicy==!0?(t(`sed -i 's/hide_vendor_sepolicy=1/hide_vendor_sepolicy=0/' ${d}/config.sh`),a.hide_vendor_sepolicy=!1,o("Reboot to take effect")):(t(`sed -i 's/hide_vendor_sepolicy=0/hide_vendor_sepolicy=1/' ${d}/config.sh`),a.hide_vendor_sepolicy=!0,o("Reboot to take effect"))}),r.addEventListener("click",async function(){a.hide_compat_matrix==!0?(t(`sed -i 's/hide_compat_matrix=1/hide_compat_matrix=0/' ${d}/config.sh`),a.hide_compat_matrix=!1,o("Reboot to take effect")):(t(`sed -i 's/hide_compat_matrix=0/hide_compat_matrix=1/' ${d}/config.sh`),a.hide_compat_matrix=!0,o("Reboot to take effect"))}),i.addEventListener("click",async function(){a.hide_gapps==!0?(await t(`sed -i 's/hide_gapps=1/hide_gapps=0/' ${d}/config.sh`),a.hide_gapps=!1,o("Reboot to take effect")):(await t(`sed -i 's/hide_gapps=0/hide_gapps=1/' ${d}/config.sh`),a.hide_gapps==!0,o("Reboot to take effect"))}),n.addEventListener("click",async function(){a.hide_revanced==!0?(await t(`sed -i 's/hide_revanced=1/hide_revanced=0/' ${d}/config.sh`),a.hide_revanced=!1,o("Reboot to take effect")):(await t(`sed -i 's/hide_revanced=0/hide_revanced=1/' ${d}/config.sh`),a.hide_revanced=!0,o("Reboot to take effect"))}),u.addEventListener("click",async function(){a.spoof_cmdline==!0?(await t(`sed -i 's/spoof_cmdline=1/spoof_cmdline=0/' ${d}/config.sh`),a.spoof_cmdline=!1,o("Reboot to take effect")):(await t(`sed -i 's/spoof_cmdline=0/spoof_cmdline=1/' ${d}/config.sh`),a.spoof_cmdline=!0,o("Reboot to take effect"))}),_.addEventListener("click",async function(){a.hide_loops==!0?(await t(`sed -i 's/hide_loops=1/hide_loops=0/' ${d}/config.sh`),a.hide_loops=!1,o("Reboot to take effect")):(await t(`sed -i 's/hide_loops=0/hide_loops=1/' ${d}/config.sh`),a.hide_loops=!0,o("Reboot to take effect"))}),f.addEventListener("click",async function(){a.force_hide_lsposed==!0?(await t(`sed -i 's/force_hide_lsposed=1/force_hide_lsposed=0/' ${d}/config.sh`),a.force_hide_lsposed=!1,o("Reboot to take effect")):(await t(`sed -i 's/force_hide_lsposed=0/force_hide_lsposed=1/' ${d}/config.sh`),a.force_hide_lsposed=!0,o("Reboot to take effect"))})}async function me(){const e=document.getElementById("load_sus_path"),s=document.getElementById("custom_sus_path"),c=document.getElementById("save_sus_path");e.addEventListener("click",async()=>{s.innerHTML=await t(`cat ${d}/sus_path.txt`)}),c.addEventListener("click",async()=>{var i=s.value;i==""?o("please press load first!"):(await t(`echo '${i}' > ${d}/sus_path.txt`),o("Custom SUS PATH saved!"),o("Reboot to take effect"))})}async function he(){const e=document.getElementById("load_sus_mount"),s=document.getElementById("custom_sus_mount"),c=document.getElementById("save_sus_mount");e.addEventListener("click",async()=>{s.innerHTML=await t(`cat ${d}/sus_mount.txt`)}),c.addEventListener("click",async()=>{var i=s.value;i==""?o("please press load first!"):(await t(`echo '${i}' > ${d}/sus_mount.txt`),o("Custom SUS MOUNT saved!"),o("Reboot to take effect"))})}async function ge(){const e=document.getElementById("load_try_umount"),s=document.getElementById("custom_try_umount"),c=document.getElementById("save_try_umount"),i=document.querySelector("main");e.addEventListener("click",async()=>{s.innerHTML=await t(`cat ${d}/try_umount.txt`)}),c.addEventListener("click",async()=>{var n=s.value;n==""?o("please press load first!"):(await t(`echo '${n}' > ${d}/try_umount.txt`),o("Custom SUS MOUNT saved!"),o("Reboot to take effect"))}),s.addEventListener("focus",()=>{i.style.paddingBottom="300px",s.scrollIntoView({behavior:"smooth",block:"center",inline:"nearest"})}),s.addEventListener("blur",()=>{F.to(i,{duration:.5,paddingBottom:"0px",ease:"power1.out"})})}function P(){const e=document.getElementById("sus_uname"),s=document.querySelector("main");e.addEventListener("focus",()=>{s.style.paddingBottom="350px",e.scrollIntoView({behavior:"smooth",block:"center",inline:"nearest"})}),e.addEventListener("blur",()=>{s.scrollTo({top:0,behavior:"smooth"}),setTimeout(()=>{s.style.paddingBottom="0px"},500)})}O(b);P();z(b);
