import 'package:flutter/material.dart';

class NotificationScreenTest extends StatefulWidget {
  const NotificationScreenTest({super.key});

  @override
  State<NotificationScreenTest> createState() => _NotificationScreenTestState();
}

class _NotificationScreenTestState extends State<NotificationScreenTest> {
  int _selectedFilterIndex = 0;
  int _selectedBottomIndex = 2; // Alerts tab selected

  final List<String> _filters = ['All', 'Bookings', 'Listings'];

  final List<NotificationItem> _notifications = [
    NotificationItem(
      icon: Icons.home_work,
      iconColor: Color(0xFF13ECC8),
      iconBgColor: Color(0xFF13ECC8).withOpacity(0.1),
      title: 'New Villa Available: Emerald Woods - Plot 42',
      description:
          'A luxury 4-bedroom villa just entered the inventory. Check specs and floor plan.',
      time: '2m ago',
      isUnread: true,
    ),
    NotificationItem(
      icon: Icons.check_circle,
      iconColor: Color(0xFF4CAF50),
      iconBgColor: Color(0xFF4CAF50).withOpacity(0.1),
      title: 'Booking Approved: Unit 204',
      description:
          'The confirmation for client John Smith is now complete. Contract ready for signing.',
      time: '1h ago',
      isUnread: false,
    ),
    NotificationItem(
      icon: Icons.sell,
      iconColor: Color(0xFFFF9800),
      iconBgColor: Color(0xFFFF9800).withOpacity(0.1),
      title: 'Promotional Price: 15% Off',
      description:
          'Limited time offer on Palm Apartments for the next 48 hours. Update your lead list.',
      time: '3h ago',
      isUnread: false,
    ),
    NotificationItem(
      icon: Icons.description,
      iconColor: Color(0xFF2196F3),
      iconBgColor: Color(0xFF2196F3).withOpacity(0.1),
      title: 'New Marketing Assets',
      description:
          'New HD renders and brochure available for Downtown Residency.',
      time: '5h ago',
      isUnread: false,
    ),
    NotificationItem(
      icon: Icons.info,
      iconColor: Color(0xFF9E9E9E),
      iconBgColor: Color(0xFF9E9E9E).withOpacity(0.1),
      title: 'System Update Complete',
      description:
          'Inventory sync issues have been resolved. Performance improved.',
      time: 'Yesterday',
      isUnread: false,
      isOld: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? Color(0xFF10221F) : Color(0xFFF6F8F8);
    final primaryColor = Color(0xFF13ECC8);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header Section
            _buildHeader(isDark, primaryColor),

            // Filter Tabs
            _buildFilterTabs(isDark, primaryColor),

            // Notification List
            Expanded(child: _buildNotificationList(isDark)),

            // Bottom Navigation Bar
            _buildBottomNavBar(isDark, primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Notifications',
            style: TextStyle(
              color: isDark ? Colors.white : Color(0xFF111827),
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                for (var notification in _notifications) {
                  notification.isUnread = false;
                }
              });
            },
            child: Text(
              'Mark all as read',
              style: TextStyle(
                color: primaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs(bool isDark, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        height: 44,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isDark
              ? Color(0xFF10B981).withOpacity(0.15)
              : Color(0xFFE5E7EB),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: List.generate(_filters.length, (index) {
            final isSelected = _selectedFilterIndex == index;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedFilterIndex = index;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (isDark ? Color(0xFF10221F) : Colors.white)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 2,
                              offset: Offset(0, 1),
                            ),
                          ]
                        : [],
                  ),
                  child: Center(
                    child: Text(
                      _filters[index],
                      style: TextStyle(
                        color: isSelected
                            ? primaryColor
                            : (isDark
                                  ? Color(0xFF6EE7B7).withOpacity(0.6)
                                  : Color(0xFF6B7280)),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildNotificationList(bool isDark) {
    return ListView.builder(
      itemCount: _notifications.length,
      itemBuilder: (context, index) {
        final notification = _notifications[index];
        return _buildNotificationItem(notification, isDark);
      },
    );
  }

  Widget _buildNotificationItem(NotificationItem notification, bool isDark) {
    final isUnread = notification.isUnread;
    final isOld = notification.isOld;

    return Container(
      decoration: BoxDecoration(
        color: isUnread
            ? (isDark ? Color(0xFF10B981).withOpacity(0.05) : Colors.white)
            : Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.white.withOpacity(0.05) : Color(0xFFF3F4F6),
            width: 1,
          ),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              notification.isUnread = false;
            });
          },
          child: Opacity(
            opacity: isOld ? 0.6 : 1.0,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon with unread indicator
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: notification.iconBgColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          notification.icon,
                          color: notification.iconColor,
                          size: 28,
                        ),
                      ),
                      if (isUnread)
                        Positioned(
                          top: -4,
                          right: -4,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Color(0xFF13ECC8),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isDark
                                    ? Color(0xFF10221F)
                                    : Colors.white,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                notification.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.white
                                      : Color(0xFF111827),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  height: 1.3,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              notification.time,
                              style: TextStyle(
                                color: isDark
                                    ? Color(0xFF6EE7B7).withOpacity(0.4)
                                    : Color(0xFF9CA3AF),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notification.description,
                          style: TextStyle(
                            color: isDark
                                ? Color(0xFFD1FAE5).withOpacity(0.6)
                                : Color(0xFF6B7280),
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavBar(bool isDark, Color primaryColor) {
    final items = [
      BottomNavItem(icon: Icons.dashboard, label: 'Dashboard'),
      BottomNavItem(icon: Icons.inventory_2, label: 'Properties'),
      BottomNavItem(icon: Icons.notifications, label: 'Alerts'),
      BottomNavItem(icon: Icons.person, label: 'Profile'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF064E3B).withOpacity(0.2) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.white.withOpacity(0.05) : Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 80,
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(items.length, (index) {
                final isSelected = _selectedBottomIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedBottomIndex = index;
                    });
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        items[index].icon,
                        color: isSelected ? primaryColor : Color(0xFF9CA3AF),
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        items[index].label,
                        style: TextStyle(
                          color: isSelected ? primaryColor : Color(0xFF9CA3AF),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          // iOS Home Indicator
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            width: 128,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.2) : Color(0xFFD1D5DB),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationItem {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String description;
  final String time;
  bool isUnread;
  final bool isOld;

  NotificationItem({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.description,
    required this.time,
    this.isUnread = false,
    this.isOld = false,
  });
}

class BottomNavItem {
  final IconData icon;
  final String label;

  BottomNavItem({required this.icon, required this.label});
}
