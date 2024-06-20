# ipv4 - init

## 入口

```c
// net/ipv4/af_inet.c

fs_initcall(inet_init);
```

`fs_initcall` 是一个宏，用于将函数指针放到指定的内存区域，便于内核初始化时运行函数。这里简单理解为将 `inet_init` 函数注册到 Linux 内核初始化流程中即可。

## inet_init

`inet_init` 函数用于初始化整个 IPv4 协议栈。

```c
// net/ipv4/af_net.c

static int __init inet_init(void)
{
	struct inet_protosw *q;
	struct list_head *r;
	int rc;

    // 检查 inet_skb_parm 大小是否与 sk_buff 控制块的大小匹配
	sock_skb_cb_check_size(sizeof(struct inet_skb_parm));

    // 协议注册，将其挂载到/proc文件系统上。通过/proc/net/protocols可以看到注册协议的统计信息
	rc = proto_register(&tcp_prot, 1);
	if (rc)
		goto out;

	rc = proto_register(&udp_prot, 1);
	if (rc)
		goto out_unregister_tcp_proto;

	rc = proto_register(&raw_prot, 1);
	if (rc)
		goto out_unregister_udp_proto;

	rc = proto_register(&ping_prot, 1);
	if (rc)
		goto out_unregister_raw_proto;

	/*
	 *	Tell SOCKET that we are alive...
	 */

    // 注册socket family, 当使用 socket(2) 中指定 family 时就能通过 inet_family_ops 中的inet_create 创建 ipv4 socket
	(void)sock_register(&inet_family_ops);

#ifdef CONFIG_SYSCTL
	ip_static_sysctl_init();
#endif

	/*
	 *	Add all the base protocols.
	 */

    // 注册传输层协议处理函数
	if (inet_add_protocol(&icmp_protocol, IPPROTO_ICMP) < 0)
		pr_crit("%s: Cannot add ICMP protocol\n", __func__);
	if (inet_add_protocol(&udp_protocol, IPPROTO_UDP) < 0)
		pr_crit("%s: Cannot add UDP protocol\n", __func__);
	if (inet_add_protocol(&tcp_protocol, IPPROTO_TCP) < 0)
		pr_crit("%s: Cannot add TCP protocol\n", __func__);
#ifdef CONFIG_IP_MULTICAST
	if (inet_add_protocol(&igmp_protocol, IPPROTO_IGMP) < 0)
		pr_crit("%s: Cannot add IGMP protocol\n", __func__);
#endif

	/* Register the socket-side information for inet_create. */
	for (r = &inetsw[0]; r < &inetsw[SOCK_MAX]; ++r)
		INIT_LIST_HEAD(r);

	for (q = inetsw_array; q < &inetsw_array[INETSW_ARRAY_LEN]; ++q)
		inet_register_protosw(q);

	/*
	 *	Set the ARP module up
	 */

	arp_init();

	/*
	 *	Set the IP module up
	 */

	ip_init();

	/* Setup TCP slab cache for open requests. */
	tcp_init();

	/* Setup UDP memory threshold */
	udp_init();

	/* Add UDP-Lite (RFC 3828) */
	udplite4_register();

	raw_init();

	ping_init();

	/*
	 *	Set the ICMP layer up
	 */

	if (icmp_init() < 0)
		panic("Failed to create the ICMP control socket.\n");

	/*
	 *	Initialise the multicast router
	 */
#if defined(CONFIG_IP_MROUTE)
	if (ip_mr_init())
		pr_crit("%s: Cannot init ipv4 mroute\n", __func__);
#endif

	if (init_inet_pernet_ops())
		pr_crit("%s: Cannot init ipv4 inet pernet ops\n", __func__);
	/*
	 *	Initialise per-cpu ipv4 mibs
	 */

	if (init_ipv4_mibs())
		pr_crit("%s: Cannot init ipv4 mibs\n", __func__);

	ipv4_proc_init();

	ipfrag_init();

	dev_add_pack(&ip_packet_type);

	ip_tunnel_core_init();

	rc = 0;
out:
	return rc;
out_unregister_raw_proto:
	proto_unregister(&raw_prot);
out_unregister_udp_proto:
	proto_unregister(&udp_prot);
out_unregister_tcp_proto:
	proto_unregister(&tcp_prot);
	goto out;
}
```

