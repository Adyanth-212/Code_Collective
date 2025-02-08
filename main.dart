import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'result_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const Page1(),
    );
  }
}

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  final TextEditingController _originController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  String? _selectedTransportMode;

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(51.5074, -0.1278), // London coordinates as example
    zoom: 12,
  );

  @override
  void dispose() {
    _originController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transport Delay Tracker'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _originController,
                decoration: InputDecoration(
                  labelText: 'Enter the origin',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'Type something...',
                  filled: true,
                  fillColor: Colors.blue[50],
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _destinationController,
                decoration: InputDecoration(
                  labelText: 'Enter the destination',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'Type something...',
                  filled: true,
                  fillColor: Colors.blue[50],
                ),
              ),
              const SizedBox(height: 20),
              const Text('Select Transport Mode:'),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10.0,
                children: [
                  _buildTransportButton(Icons.directions_bus, 'Bus'),
                  _buildTransportButton(Icons.directions_subway, 'Metro'),
                  _buildTransportButton(Icons.directions_car, 'Car'),
                  _buildTransportButton(Icons.directions_bike, 'Bike'),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[400]!),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: GoogleMap(
                    initialCameraPosition: _initialPosition,
                    zoomControlsEnabled: false,
                    scrollGesturesEnabled: false,
                    zoomGesturesEnabled: false,
                    rotateGesturesEnabled: false,
                    tiltGesturesEnabled: false,
                    mapType: MapType.normal,
                    myLocationButtonEnabled: false,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_originController.text.isNotEmpty &&
                      _destinationController.text.isNotEmpty &&
                      _selectedTransportMode != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultPage(
                          origin: _originController.text,
                          destination: _destinationController.text,
                          transportMode: _selectedTransportMode!,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill in all fields'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: const Text('Submit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransportButton(IconData icon, String mode) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTransportMode = mode;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _selectedTransportMode == mode ? Colors.blue : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _selectedTransportMode == mode ? Colors.blue : Colors.grey,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: _selectedTransportMode == mode ? Colors.white : Colors.grey,
            ),
            const SizedBox(height: 4),
            Text(
              mode,
              style: TextStyle(
                color: _selectedTransportMode == mode ? Colors.white : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}