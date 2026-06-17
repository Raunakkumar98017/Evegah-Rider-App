import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum BatteryUIState { disconnected, pairing, connected }

class BatteryDashboardScreen extends StatefulWidget {
  const BatteryDashboardScreen({super.key});

  @override
  State<BatteryDashboardScreen> createState() => _BatteryDashboardScreenState();
}

class _BatteryDashboardScreenState extends State<BatteryDashboardScreen> with TickerProviderStateMixin {
  // UI State
  BatteryUIState _uiState = BatteryUIState.disconnected;

  // Battery Data
  final int _soc = 87;
  final double _remainingCapacity = 24.8;
  final double _voltage = 51.2;
  final double _current = 5.2; 
  final double _temperature = 28.0;
  final int _soh = 92;
  final int _estimatedRange = 42;
  final String _lastUpdatedTime = "just now";
  final String _vehicleId = "EVG-SCOOTER-102";

  // Realistic mock data arrays for sparklines
  final List<double> _voltageData = [49.8, 50.1, 50.5, 50.9, 51.0, 51.2, 51.2];
  final List<double> _currentData = [0.0, 1.2, 3.4, 4.8, 5.0, 5.2, 5.2];
  final List<double> _tempData = [25.0, 25.5, 26.2, 27.0, 27.5, 27.8, 28.0];

  late AnimationController _progressController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    if (_uiState == BatteryUIState.connected) {
      _progressController.forward();
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _handleConnect() {
    setState(() => _uiState = BatteryUIState.pairing);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _uiState = BatteryUIState.connected);
        _progressController.forward(from: 0.0);
      }
    });
  }

  void _handleDisconnect() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Disconnect Battery", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text("Are you sure you want to disconnect from $_vehicleId?", style: GoogleFonts.poppins()),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: GoogleFonts.poppins(color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _uiState = BatteryUIState.disconnected);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text("Disconnect", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Battery Dashboard",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20, color: const Color(0xFF1E1452)),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1E1452), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_uiState == BatteryUIState.connected)
            IconButton(
              icon: const Icon(Icons.bluetooth_connected_rounded, color: Colors.green),
              onPressed: _handleDisconnect,
              tooltip: "Disconnect",
            )
          else if (_uiState == BatteryUIState.disconnected)
            IconButton(
              icon: Icon(Icons.bluetooth_disabled_rounded, color: Colors.red.shade400),
              onPressed: null,
            ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 600),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        child: _uiState == BatteryUIState.connected 
          ? _buildConnectedDashboard()
          : _buildDisconnectedState(),
      ),
    );
  }

  // ==========================================
  // DISCONNECTED & PAIRING STATE
  // ==========================================
  Widget _buildDisconnectedState() {
    bool isPairing = _uiState == BatteryUIState.pairing;
    return SingleChildScrollView(
      key: const ValueKey("disconnected"),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          _buildPulsingVehicleImage(isPairing),
          const SizedBox(height: 40),
          Text(
            isPairing ? "Pairing Vehicle..." : "No Vehicle Connected",
            style: GoogleFonts.poppins(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E1452),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              isPairing 
                ? "Establishing a secure connection to your EVagah smart battery. Please wait."
                : "Connect to your assigned vehicle via Bluetooth to monitor battery health, range, and live diagnostics.",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 40),
          if (isPairing)
            const CircularProgressIndicator(color: Color(0xFF4B1DB8), strokeWidth: 3)
          else
            _buildConnectButton(),
          const SizedBox(height: 40),
          _buildAssignmentCard(),
        ],
      ),
    );
  }

  Widget _buildPulsingVehicleImage(bool isPairing) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final double scale = isPairing ? 1.0 + (_pulseController.value * 0.05) : 1.0;
        final double glowOpacity = isPairing ? _pulseController.value * 0.4 : 0.0;
        
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF4B1DB8).withValues(alpha: glowOpacity),
                boxShadow: [
                  if (isPairing)
                    BoxShadow(
                      color: const Color(0xFF4B1DB8).withValues(alpha: glowOpacity),
                      blurRadius: 40,
                      spreadRadius: 20,
                    ),
                ],
              ),
            ),
            Transform.scale(
              scale: scale,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFF0F1FA),
                  border: Border.all(color: Colors.white, width: 8),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, 10)),
                  ],
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/evegah_rider_scooter.png',
                    width: 140,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Icon(Icons.electric_scooter, size: 80, color: Colors.grey.shade400),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildConnectButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _handleConnect,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2A1B70), Color(0xFF4B1DB8)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(color: const Color(0xFF4B1DB8).withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8)),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.bluetooth_rounded, color: Color(0xFFD8F238), size: 24),
              const SizedBox(width: 12),
              Text(
                "Connect Battery",
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAssignmentCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100, width: 1.5),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(16)),
            child: Icon(Icons.info_outline_rounded, color: Colors.grey.shade400, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Assigned Vehicle", style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(_vehicleId, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF1E1452))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // CONNECTED DASHBOARD STATE
  // ==========================================
  Widget _buildConnectedDashboard() {
    return SingleChildScrollView(
      key: const ValueKey("connected"),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeroCard(),
          const SizedBox(height: 16),
          _buildVehicleInfoCard(),
          const SizedBox(height: 16),
          _buildBatteryHealthSummaryCard(),
          const SizedBox(height: 24),
          Text(
            "Live Analytics",
            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF1E1452)),
          ),
          const SizedBox(height: 16),
          _buildMetricsGrid(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2A1B70), Color(0xFF4B1DB8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(color: const Color(0xFF4B1DB8).withValues(alpha: 0.4), blurRadius: 24, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFD8F238),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: const Color(0xFFD8F238).withValues(alpha: 0.3), blurRadius: 8)],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.bolt_rounded, color: Color(0xFF1E1452), size: 14),
                    const SizedBox(width: 4),
                    Text(
                      "Connected & Charging",
                      style: GoogleFonts.poppins(color: const Color(0xFF1E1452), fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Text(
                "Sync: $_lastUpdatedTime",
                style: GoogleFonts.poppins(color: Colors.white.withValues(alpha: 0.7), fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Battery Level",
                    style: GoogleFonts.poppins(color: Colors.white.withValues(alpha: 0.8), fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      TweenAnimationBuilder<int>(
                        tween: IntTween(begin: 0, end: _soc),
                        duration: const Duration(milliseconds: 1500),
                        curve: Curves.easeOutQuart,
                        builder: (context, value, child) {
                          return Text(
                            "$value",
                            style: GoogleFonts.poppins(color: Colors.white, fontSize: 64, fontWeight: FontWeight.bold, height: 1.1),
                          );
                        },
                      ),
                      Text(
                        "%",
                        style: GoogleFonts.poppins(color: Colors.white.withValues(alpha: 0.9), fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Column(
                  children: [
                    const Icon(Icons.route_rounded, color: Color(0xFFD8F238), size: 28),
                    const SizedBox(height: 4),
                    Text(
                      "$_estimatedRange km",
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100, width: 1.5),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFF4B1DB8).withValues(alpha: 0.08), borderRadius: BorderRadius.circular(16)),
            child: const Icon(Icons.electric_scooter_rounded, color: Color(0xFF4B1DB8), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Assigned Vehicle", style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(_vehicleId, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF1E1452))),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(12)),
            child: Text(
              "Active",
              style: GoogleFonts.poppins(color: Colors.green.shade700, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBatteryHealthSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100, width: 1.5),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.health_and_safety_rounded, color: Colors.green, size: 20),
              const SizedBox(width: 8),
              Text("Battery Health", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF1E1452))),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildHealthStat("State of Health", "$_soh%", Icons.favorite_rounded, Colors.red.shade400),
              _buildHealthStat("Temperature", "$_temperature°C", Icons.thermostat_rounded, Colors.orange.shade500),
              _buildHealthStat("Capacity", "$_remainingCapacity Ah", Icons.battery_charging_full_rounded, Colors.blue.shade500),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHealthStat(String label, String value, IconData icon, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 14),
            const SizedBox(width: 4),
            Text(label, style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
          ],
        ),
        const SizedBox(height: 4),
        Text(value, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF1E1452))),
      ],
    );
  }

  Widget _buildMetricsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSimpleMetricCard(
                "Voltage",
                "$_voltage V",
                Icons.electric_bolt_rounded,
                const Color(0xFF4B1DB8),
                _voltageData,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSimpleMetricCard(
                "Current",
                "+$_current A",
                Icons.waves_rounded,
                Colors.teal,
                _currentData,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildSimpleMetricCard(
                "Temperature",
                "$_temperature °C",
                Icons.thermostat_rounded,
                Colors.orange.shade600,
                _tempData,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSimpleMetricCard(
                "Cycles",
                "42",
                Icons.loop_rounded,
                Colors.blue.shade600,
                [38, 39, 40, 40, 41, 41, 42],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSimpleMetricCard(String title, String value, IconData icon, Color color, List<double> chartData) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 15, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, color: color, size: 16),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(title, style: GoogleFonts.poppins(color: Colors.grey.shade500, fontSize: 13, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(value, style: GoogleFonts.poppins(color: const Color(0xFF1E1452), fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          SizedBox(
            height: 40,
            child: CustomPaint(
              painter: RealSparklinePainter(color: color, data: chartData),
              size: const Size(double.infinity, 40),
            ),
          ),
        ],
      ),
    );
  }
}

// A polished sparkline painter that uses real data bounds to draw realistic curves
class RealSparklinePainter extends CustomPainter {
  final Color color;
  final List<double> data;

  RealSparklinePainter({required this.color, required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    
    double minVal = data.reduce((a, b) => a < b ? a : b);
    double maxVal = data.reduce((a, b) => a > b ? a : b);
    if (maxVal == minVal) {
      maxVal += 1;
      minVal -= 1;
    }

    double stepX = size.width / (data.length - 1);
    
    for (int i = 0; i < data.length; i++) {
      double normalizedY = (data[i] - minVal) / (maxVal - minVal);
      double x = i * stepX;
      double y = size.height - (normalizedY * size.height);
      
      // Add padding top and bottom so lines don't get clipped
      y = y.clamp(3.0, size.height - 3.0);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        double prevX = (i - 1) * stepX;
        double prevY = size.height - (((data[i - 1] - minVal) / (maxVal - minVal)) * size.height);
        prevY = prevY.clamp(3.0, size.height - 3.0);
        
        // Bezier curve for smoothness
        double controlX1 = prevX + (stepX / 2);
        double controlY1 = prevY;
        double controlX2 = prevX + (stepX / 2);
        double controlY2 = y;
        
        path.cubicTo(controlX1, controlY1, controlX2, controlY2, x, y);
      }
    }

    canvas.drawPath(path, paint);
    
    // Gradient fill under curve
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withValues(alpha: 0.2), color.withValues(alpha: 0.0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;
      
    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
      
    canvas.drawPath(fillPath, fillPaint);
  }

  @override
  bool shouldRepaint(covariant RealSparklinePainter oldDelegate) {
    return oldDelegate.data != data || oldDelegate.color != color;
  }
}
