window.env = {};

window.env.strout = function strout(memory, p, l) {
        var buf = new Uint8Array(memory.buffer, p, l);
        var s = "";
        var i;

        for (i = 0; i < l && buf[i]; i++)
                s += String.fromCharCode(buf[i]);

        return s;
};

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

var progs = { 0: 'kern' }

window.env.umem = function umem(pid, d, o, len) {
        return bmemcpy(memory, progs[pid].memory, d, o, len);
};

window.env.kmem = function kmem(pid, d, o, len) {
        return bmemcpy(progs[pid].memory, memory, d, o, len);
};

// var shbuf;

window.env.js_emem = function js_emem(ofs, p, p_len) {
        return bcpy(memory.buffer, shbuf, p, ofs, p_len);
}

window.env.evt_count = function evt_count(ms) {
        return 0;
};

window.env.js_run = function js_run(ptr, len) {
        var buf = new Uint8Array(memory.buffer, ptr, len);
        var path = _jsnstr(buf, len);

        run(path);
};

window.env.flush = function flush(p, l) {};
window.env.js_shutdown = function js_shutdown(e) {};
window.env.tty_read = function tty_read() {};
// export function js_sleep() {}

window.env.strin = function strin(mem, ptr, str, maxlen) {
        var wm = new Uint8Array(mem.buffer);
        var
	enc = new TextEncoder();
        var bbuf = enc.encode(str);
        var i;
        // var buf = new Uint8Array(mem.buffer, ptr, maxlen);
        for (i = 0; i < bbuf.length; i++)
                wm[ptr + i] = bbuf[i];
        wm[ptr + i] = enc.encode("\0")[0];
};
