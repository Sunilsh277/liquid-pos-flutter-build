import 'package:flutter/material.dart';
import '../backend/liquid_pos_repository.dart';

/// Kitchen board grouped by the backend's new / preparing / ready states.
class KitchenScreen extends StatefulWidget {
  const KitchenScreen({super.key, required this.repository});
  final LiquidPosRepository repository;
  @override State<KitchenScreen> createState() => _KitchenScreenState();
}
class _KitchenScreenState extends State<KitchenScreen> {
  late Future<Map<String, List<Map<String, dynamic>>>> _future;
  final Set<String> _busy = {};
  @override void initState() { super.initState(); _future = widget.repository.kitchenBoard(); }
  void _reload() => setState(() => _future = widget.repository.kitchenBoard());
  String _id(Map<String,dynamic> row) => (row['_id'] ?? row['id'] ?? '').toString();
  Future<void> _advance(Map<String,dynamic> ticket, String next) async {
    final id = _id(ticket); if (id.isEmpty) return;
    setState(() => _busy.add(id));
    try { await widget.repository.setKitchenTicketStatus(id, next); if (!mounted) return; _reload(); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ticket moved to $next.'))); }
    catch (e) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not update ticket: $e'))); }
    finally { if (mounted) setState(() => _busy.remove(id)); }
  }
  @override Widget build(BuildContext context) => RefreshIndicator(onRefresh: () async => _reload(), child: FutureBuilder<Map<String,List<Map<String,dynamic>>>>(future:_future,builder:(context,snapshot){
    if(snapshot.connectionState==ConnectionState.waiting) return const Center(child:CircularProgressIndicator());
    if(snapshot.hasError) return ListView(padding:const EdgeInsets.all(24),children:[const Icon(Icons.cloud_off_outlined,size:48),const SizedBox(height:12),const Text('Could not load kitchen tickets',textAlign:TextAlign.center,style:TextStyle(fontSize:18,fontWeight:FontWeight.bold)),const SizedBox(height:8),Text(snapshot.error.toString(),textAlign:TextAlign.center),Center(child:TextButton.icon(onPressed:_reload,icon:const Icon(Icons.refresh),label:const Text('Retry')))]);
    final board=snapshot.data ?? const <String,List<Map<String,dynamic>>>{};
    final columns=[('new','New',Colors.blue),('preparing','Preparing',Colors.orange),('ready','Ready',Colors.green)];
    return ListView(scrollDirection:Axis.horizontal,padding:const EdgeInsets.all(12),children:[for(final column in columns) SizedBox(width:MediaQuery.sizeOf(context).width>1000?360:MediaQuery.sizeOf(context).width*.84,child:Padding(padding:const EdgeInsets.only(right:12),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Row(children:[Container(width:10,height:10,decoration:BoxDecoration(color:column.$3,shape:BoxShape.circle)),const SizedBox(width:8),Text(column.$2,style:const TextStyle(fontSize:18,fontWeight:FontWeight.w800)),const SizedBox(width:8),Chip(label:Text('${(board[column.$1]??const []).length}'))]),const SizedBox(height:8),Expanded(child:(board[column.$1]??const []).isEmpty?const Center(child:Text('No tickets')):ListView.builder(itemCount:(board[column.$1]??const []).length,itemBuilder:(context,index){final ticket=(board[column.$1]??const [])[index];final id=_id(ticket);final items=ticket['items'] is List ? ticket['items'] as List : const [];final next=column.$1=='new'?'preparing':column.$1=='preparing'?'ready':'served';return Card(child:Padding(padding:const EdgeInsets.all(14),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Row(children:[Expanded(child:Text('Ticket #${ticket['ticketNumber']??'—'}',style:const TextStyle(fontWeight:FontWeight.w800,fontSize:17))),Text((ticket['tableName']??ticket['orderType']??'').toString(),style:const TextStyle(color:Colors.black54))]),if(ticket['customerName']!=null)Text(ticket['customerName'].toString()),const Divider(),for(final raw in items.whereType<Map>()) Padding(padding:const EdgeInsets.symmetric(vertical:3),child:Text('${raw['quantity']??1} × ${raw['name']??'Item'}${raw['variantName']==null?'':' (${raw['variantName']})'}${raw['instructions']==null?'':' — ${raw['instructions']}'}')),if(ticket['note']!=null)Padding(padding:const EdgeInsets.only(top:6),child:Text('Note: ${ticket['note']}')),const SizedBox(height:10),Align(alignment:Alignment.centerRight,child:FilledButton(onPressed:id.isEmpty||_busy.contains(id)?null:()=>_advance(ticket,next),child:_busy.contains(id)?const SizedBox(width:16,height:16,child:CircularProgressIndicator(strokeWidth:2)):Text(next=='served'?'Mark served':'Move to $next')))])));}))) ]))) ]);
  }));
}
