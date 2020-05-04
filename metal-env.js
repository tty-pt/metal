function _jsnstr(buf, l) {
        let s = "";
        let i;

        for (i = 0; i < l; i++)
                s += String.fromCharCode(buf[i]);

        return s;
}

export function jsnstr(mem, p, l) {
        return _jsnstr(new Uint8Array(mem, p, l), l);
}

export let memory_resolve;
let memory_p = new Promise(function (resolve) {
        memory_resolve = resolve
});

export function console_log(p, l) {
        memory_p.then(memory => {
                console.log(jsnstr(memory.buffer, p, l));
        });
}

function bcpy(bufd, bufo, d, o, len) {
        try {
                (new Uint8Array(bufd, d, len))
                        .set(new Uint8Array(bufo, o, len));

                return len;
        } catch (e) {
                console.error(e);
                return -1;
        }
}

function bmemcpy(memd, memo, d, o, len) {
        return bcpy(memd.buffer, memo.buffer, d, o, len);
}

let progs = { 0: 'kern' }

export function umem(pid, d, o, len) {
        return bmemcpy(memory, progs[pid].memory, d, o, len);
}

export function kmem(pid, d, o, len) {
        return bmemcpy(progs[pid].memory, memory, d, o, len);
}

// let shbuf;

export function js_emem(ofs, p, p_len) {
        return bcpy(memory.buffer, shbuf, p, ofs, p_len);
}

// function init(_shbuf) {
        // shbuf = _shbuf;
        // evt_n = new Int32Array(shbuf, 0, 1);
        // self.onmessage = null;
// }

// let got_events = new Promise(resolve => {
//         self.onmessage = event => resolve(init(event.data));
// });

let evt_n;

export function evt_count(ms) {
        return 0;
}

// function evt_count(ms) {
//         if (Atomics.wait(evt_n, 0, 0, ms) == 'timed-out')
//                 return -1;

//         return Atomics.exchange(evt_n, 0, 0);
// }

export function js_run(ptr, len) {
        const buf = new Uint8Array(memory.buffer, ptr, len);
        const path = _jsnstr(buf, len);

        run(path);
}

export function flush(p, l) {
//         const str = jsnstr(memory.buffer, p, l);
// 	postMessage(str);
}

export function js_shutdown(e) {}
function js_sleep() {}
const kenv = {
        console_log,
        flush,
        umem,
        kmem,

        js_shutdown,
        js_sleep,

        js_emem,
        evt_count,
        js_run,

        memory: new WebAssembly.Memory({
                initial: 1,
                maximum: 32,
        }),
};

// function wasm_load(path, env) {
//         console.log("WASM_LOAD", path, env);
//         return fetch(path)
//                 .then(res => res.arrayBuffer())
//                 .then(buf => {
//                         const mod = new WebAssembly.Module(buf)
//                         return (new WebAssembly.Instance(mod, { env })).exports;
//                 });
// }

let syscall, evt_loop;

// const booted = wasm_load(
//         '/wasm/bin/metal.wasm',
//         kenv,
// ).then(exports => {
//         memory = exports.memory;
//         syscall = {
//                 __syscall0: exports.__syscall0,
//                 __syscall1: exports.__syscall1,
//                 __syscall2: exports.__syscall2,
//                 __syscall3: exports.__syscall3,
//                 __syscall4: exports.__syscall4,
//                 __syscall5: exports.__syscall5,
//                 __syscall6: exports.__syscall6,
//         };
//         exports.start_kernel();
//         // evt_loop = exports.evt_loop;
//         // evt_loop();
//         return syscall;
// });

let next_pid = 1;

function run(path, env = memory => {}) {
        let prog = {};
        let dead;

        progs[next_pid] = prog;
        next_pid++;
        let save = {};

        return booted.then(() => wasm_load(path, { ...env(prog), ...syscall })).then(exports => {
                dead = exports.dead;
                save.exports = exports;
                prog.memory = exports.memory;
                console.log(exports);
                // exports._start(exports.argc);
                // dead();
                return exports;
        // }).catch(err => {
        //         // 'unreachable executed'
        //         if (err.message == 'unreachable' && dead)
        //                 dead();
        //         else
        //                 setTimeout(function () { throw err; }, 0);
        //         return save;
        });
        // }).finally(evt_loop);
}

// function write(buf, data, i, len) {
//         let j;

//         for (j = 0; j < len; j++, i++)
//                 Atomics.store(buf, i, data[j]);
// }

export function strin(mem, ptr, str, maxlen) {
        const wm = new Uint8Array(mem.buffer);
        const enc = new TextEncoder();
        const bbuf = enc.encode(str);
        let i;
        // let buf = new Uint8Array(mem.buffer, ptr, maxlen);
        for (i = 0; i < bbuf.length; i++)
                wm[ptr + i] = bbuf[i];
        wm[ptr + i] = enc.encode("\0")[0];
}
