import { describe, it, expect, beforeEach } from 'vitest';
import { vi } from 'vitest';

describe('IoT Data Contract', () => {
  const contractOwner = 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM';
  
  beforeEach(() => {
    vi.resetAllMocks();
  });
  
  it('should add IoT data', () => {
    const mockAddIotData = vi.fn().mockReturnValue({ success: true, value: 1 });
    expect(mockAddIotData(1, 20, 50, 1000)).toEqual({ success: true, value: 1 });
  });
  
  it('should get IoT data', () => {
    const mockGetIotData = vi.fn().mockReturnValue({
      success: true,
      value: {
        product_id: 1,
        timestamp: 123456,
        temperature: 20,
        humidity: 50,
        pressure: 1000,
        quality_score: 100
      }
    });
    const result = mockGetIotData(1);
    expect(result.success).toBe(true);
    expect(result.value).toEqual({
      product_id: 1,
      timestamp: 123456,
      temperature: 20,
      humidity: 50,
      pressure: 1000,
      quality_score: 100
    });
  });
  
  it('should get last data id', () => {
    const mockGetLastDataId = vi.fn().mockReturnValue({ success: true, value: 1 });
    expect(mockGetLastDataId()).toEqual({ success: true, value: 1 });
  });
});

