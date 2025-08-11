const assert = require('assert');
const fetch = (...args) => import('node-fetch').then(({ default: fetch }) => fetch(...args));

suite('Home page', function() {
  test('Page title', async function() {
    let res = await fetch("http://localhost:8888/");
    let body = await res.text();
    assert.ok(body.includes("<h1>Students Registry</h1>"));
  });
  
  test('Students count', async function() {
    let res = await fetch("http://localhost:8888/");
    let body = await res.text();
    assert.ok(body.includes("Registered students: <b>2</b>"));
  });
});
