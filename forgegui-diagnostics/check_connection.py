import json, pathlib, urllib.request, urllib.error, sys
CONFIG=pathlib.Path(r"C:\Users\karti\OneDrive\Documents\Outpost\forgegui_config.json")
ENDPOINT="https://azyjlkhpdgafuobyxoax.supabase.co/functions/v1/forgegui-mcp"
config=json.loads(CONFIG.read_text(encoding="utf-8-sig"))
key=config.get("api_key","")
if config.get("endpoint")!=ENDPOINT or not key:
    raise SystemExit("Endpoint mismatch or missing stored credential")
class NoRedirect(urllib.request.HTTPRedirectHandler):
    def redirect_request(self,*args,**kwargs): return None
opener=urllib.request.build_opener(NoRedirect)
def rpc(method,params,rid):
    req=urllib.request.Request(ENDPOINT,data=json.dumps({"jsonrpc":"2.0","id":rid,"method":method,"params":params}).encode(),
        headers={"Authorization":"Bearer "+key,"Content-Type":"application/json","Accept":"application/json, text/event-stream","X-ForgeGUI-Plugin-Version":"1.9.6","X-ForgeGUI-Plugin-Client":"codex"})
    try:
        with opener.open(req,timeout=25) as resp:
            raw=resp.read().decode()
            print(json.dumps({"method":method,"httpStatus":resp.status}))
    except urllib.error.HTTPError as e:
        raw=e.read().decode(errors="replace")
        print(json.dumps({"method":method,"httpStatus":e.code,"error":raw.replace(key,"[REDACTED]")[:1200]}))
        raise SystemExit(2)
    except Exception as e:
        print(json.dumps({"method":method,"connectionError":str(e).replace(key,"[REDACTED]")}))
        raise SystemExit(3)
    try: return json.loads(raw)
    except json.JSONDecodeError:
        events=[json.loads(line[6:]) for line in raw.splitlines() if line.startswith("data: ") and line[6:]!="[DONE]"]
        return next((e for e in events if e.get("id")==rid),{})
if len(sys.argv)>1 and sys.argv[1]=="search":
    payload=json.loads((pathlib.Path(__file__).parent/"free-search.json").read_text())
    result=rpc("tools/call",payload,3)
    # Redact the known credential defensively, and cap account/library output.
    print(json.dumps(result).replace(key,"[REDACTED]")[:4500])
else:
    init=rpc("initialize",{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"codex-forgegui-diagnostic","version":"1.0"}},1)
    print(json.dumps({"initialize":init.get("result",{}).get("serverInfo"),"error":init.get("error")}))
    result=rpc("tools/list",{},2)
    if "error" in result:
        print(json.dumps(result).replace(key,"[REDACTED]")[:2000]);raise SystemExit(2)
    tools=result.get("result",{}).get("tools",[])
    (pathlib.Path(__file__).parent/"tools.json").write_text(json.dumps(tools,indent=2),encoding="utf-8")
    print(json.dumps({"toolCount":len(tools),"tools":[t["name"] for t in tools]}))
    for t in tools:
        if "library" in t["name"] and "search" in t["name"]:
            print(json.dumps(t).replace(key,"[REDACTED]")[:10000])
